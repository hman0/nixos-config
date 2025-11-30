#!/usr/bin/env bash
# Script to cycle between TLP Battery, Balanced Gaming, and Max Performance modes (Thinkpad X13s)
STATE_FILE="/tmp/tlp_gaming_mode"

apply_balanced_gaming_settings() {
    # Use 'schedutil' or 'ondemand' governor - more responsive than powersave, less aggressive than performance
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "schedutil" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Set balanced energy preference instead of full performance
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        if [ -f "$cpu" ]; then
            echo "balance_performance" | doas tee "$cpu" > /dev/null 2>&1
        fi
    done
    
    # Allow lower minimum frequency - CPU can downclock when idle
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
        echo "800000" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Set max frequency to ~80% of maximum (2.4 GHz instead of 3.0 GHz)
    # Still plenty for gaming, much better battery life
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
        echo "2400000" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Keep turbo boost enabled but it won't hit max due to frequency cap
    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        echo "0" | doas tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1
    fi
    if [ -f /sys/devices/system/cpu/cpufreq/boost ]; then
        echo "1" | doas tee /sys/devices/system/cpu/cpufreq/boost > /dev/null 2>&1
    fi
    
    # Use balanced platform profile instead of performance
    if [ -f /sys/firmware/acpi/platform_profile ]; then
        echo "balanced" | doas tee /sys/firmware/acpi/platform_profile > /dev/null 2>&1
    fi
    
    # Keep PCI power management for non-critical devices
    for device in /sys/bus/pci/devices/*/power/control; do
        echo "auto" | doas tee "$device" > /dev/null 2>&1
    done
    
    # Allow moderate USB autosuspend (5 seconds instead of disabled)
    for device in /sys/bus/usb/devices/*/power/autosuspend; do
        echo "5000" | doas tee "$device" > /dev/null 2>&1
    done
}

apply_max_performance_settings() {
    # Use performance governor for maximum responsiveness
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "performance" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Set performance energy preference
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        if [ -f "$cpu" ]; then
            echo "performance" | doas tee "$cpu" > /dev/null 2>&1
        fi
    done
    
    # Set minimum frequency high to avoid downclocking
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
        echo "1800000" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Set max frequency to maximum available
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
        MAX_AVAILABLE=$(cat "${cpu/scaling_max_freq/cpuinfo_max_freq}" 2>/dev/null || echo "3000000")
        echo "$MAX_AVAILABLE" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Enable turbo boost
    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        echo "0" | doas tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1
    fi
    if [ -f /sys/devices/system/cpu/cpufreq/boost ]; then
        echo "1" | doas tee /sys/devices/system/cpu/cpufreq/boost > /dev/null 2>&1
    fi
    
    # Use performance platform profile
    if [ -f /sys/firmware/acpi/platform_profile ]; then
        echo "performance" | doas tee /sys/firmware/acpi/platform_profile > /dev/null 2>&1
    fi
    
    # Disable PCI power management
    for device in /sys/bus/pci/devices/*/power/control; do
        echo "on" | doas tee "$device" > /dev/null 2>&1
    done
    
    # Disable USB autosuspend
    for device in /sys/bus/usb/devices/*/power/autosuspend; do
        echo "-1" | doas tee "$device" > /dev/null 2>&1
    done
    for device in /sys/bus/usb/devices/*/power/control; do
        echo "on" | doas tee "$device" > /dev/null 2>&1
    done
}

# Determine current mode and cycle to next
if [ -f "$STATE_FILE" ]; then
    CURRENT_MODE=$(cat "$STATE_FILE")
else
    CURRENT_MODE="battery"
fi

case "$CURRENT_MODE" in
    battery)
        MODE="balanced"
        notify-send "TLP Mode" "Switching to Balanced Gaming" -t 3000 -u normal
        ;;
    balanced)
        MODE="maxperf"
        notify-send "TLP Mode" "Switching to Maximum Performance" -t 3000 -u normal
        ;;
    *)
        MODE="battery"
        notify-send "TLP Mode" "Switching to Battery Optimization" -t 3000 -u normal
        ;;
esac

if [ "$MODE" = "balanced" ]; then
    # Stop any existing monitor
    if [ -f /tmp/tlp_gaming_monitor.pid ]; then
        OLD_PID=$(cat /tmp/tlp_gaming_monitor.pid)
        if kill -0 "$OLD_PID" 2>/dev/null; then
            kill "$OLD_PID" 2>/dev/null
        fi
        rm -f /tmp/tlp_gaming_monitor.pid
    fi
    
    # Apply balanced gaming settings
    apply_balanced_gaming_settings
    
    echo "balanced" > "$STATE_FILE"
    
    # Monitor and reapply settings if TLP overrides them
    (
        LAST_GOV=""
        while [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "balanced" ]; do
            CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
            if [ "$CURRENT_GOV" != "schedutil" ] && [ "$CURRENT_GOV" != "$LAST_GOV" ]; then
                apply_balanced_gaming_settings
                LAST_GOV="$CURRENT_GOV"
            fi
            sleep 5
        done
    ) &
    echo $! > /tmp/tlp_gaming_monitor.pid
    
elif [ "$MODE" = "maxperf" ]; then
    # Stop any existing monitor
    if [ -f /tmp/tlp_gaming_monitor.pid ]; then
        OLD_PID=$(cat /tmp/tlp_gaming_monitor.pid)
        if kill -0 "$OLD_PID" 2>/dev/null; then
            kill "$OLD_PID" 2>/dev/null
        fi
        rm -f /tmp/tlp_gaming_monitor.pid
    fi
    
    # Apply maximum performance settings
    apply_max_performance_settings
    
    echo "maxperf" > "$STATE_FILE"
    
    # Monitor and reapply settings if TLP overrides them
    (
        LAST_GOV=""
        while [ -f "$STATE_FILE" ] && [ "$(cat "$STATE_FILE")" = "maxperf" ]; do
            CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
            if [ "$CURRENT_GOV" != "performance" ] && [ "$CURRENT_GOV" != "$LAST_GOV" ]; then
                apply_max_performance_settings
                LAST_GOV="$CURRENT_GOV"
            fi
            sleep 5
        done
    ) &
    echo $! > /tmp/tlp_gaming_monitor.pid
    
else
    # Return to TLP management (battery mode)
    rm -f "$STATE_FILE"
    
    if [ -f /tmp/tlp_gaming_monitor.pid ]; then
        kill $(cat /tmp/tlp_gaming_monitor.pid) 2>/dev/null
        rm -f /tmp/tlp_gaming_monitor.pid
    fi
    
    # Restart TLP to restore default battery-saving settings
    doas systemctl restart tlp.service
fi

# Display status
sleep 0.5
GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")
MIN_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 2>/dev/null || echo "0")
MAX_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 2>/dev/null || echo "0")
MIN_MHZ=$((MIN_FREQ / 1000))
MAX_MHZ=$((MAX_FREQ / 1000))
TLP_STATUS=$(systemctl is-active tlp.service 2>/dev/null || echo "inactive")

case "$MODE" in
    balanced)
        notify-send "Balanced Gaming Mode" "CPU: $GOVERNOR\nFreq: ${MIN_MHZ}-${MAX_MHZ} MHz\nTLP: $TLP_STATUS" -t 4000 -u normal
        ;;
    maxperf)
        notify-send "Maximum Performance Mode" "CPU: $GOVERNOR\nFreq: ${MIN_MHZ}-${MAX_MHZ} MHz\nTLP: $TLP_STATUS" -t 4000 -u normal
        ;;
    *)
        notify-send "Battery Optimization" "CPU: $GOVERNOR\nFreq: ${MIN_MHZ}-${MAX_MHZ} MHz\nTLP: $TLP_STATUS" -t 4000 -u normal
        ;;
esac
