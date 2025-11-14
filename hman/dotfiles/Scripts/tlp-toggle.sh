#!/usr/bin/env bash
# Script to toggle between TLP Battery mode and Balanced Gaming mode (Thinkpad X13s)
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
    # Only force 'on' for GPU and critical gaming devices
    for device in /sys/bus/pci/devices/*/power/control; do
        # You can add specific device filtering here if needed
        echo "auto" | doas tee "$device" > /dev/null 2>&1
    done
    
    # Allow moderate USB autosuspend (5 seconds instead of disabled)
    for device in /sys/bus/usb/devices/*/power/autosuspend; do
        echo "5000" | doas tee "$device" > /dev/null 2>&1
    done
}

# Check current mode
if [ -f "$STATE_FILE" ]; then
    MODE="battery"
    notify-send "TLP Mode" "Switching to Battery Optimization" -t 3000 -u normal
else
    MODE="gaming"
    notify-send "TLP Mode" "Switching to Balanced Gaming" -t 3000 -u normal
fi

if [ "$MODE" = "gaming" ]; then
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
    
    touch "$STATE_FILE"
    
    # Monitor and reapply settings if TLP overrides them
    (
        LAST_GOV=""
        while [ -f "$STATE_FILE" ]; do
            CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
            if [ "$CURRENT_GOV" != "schedutil" ] && [ "$CURRENT_GOV" != "$LAST_GOV" ]; then
                apply_balanced_gaming_settings
                LAST_GOV="$CURRENT_GOV"
            fi
            sleep 5  # Check less frequently to save battery
        done
    ) &
    echo $! > /tmp/tlp_gaming_monitor.pid
    
else
    # Return to TLP management
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
EPP=$(cat /sys/devices/system/cpu/cpu0/cpufreq/energy_performance_preference 2>/dev/null || echo "unknown")

if [ "$MODE" = "gaming" ]; then
    notify-send "Balanced Gaming Mode" "CPU: $GOVERNOR\nEPP: $EPP\nFreq: ${MIN_MHZ}-${MAX_MHZ} MHz\nTLP: $TLP_STATUS" -t 4000 -u normal
else
    notify-send "Battery Optimization" "CPU: $GOVERNOR\nEPP: $EPP\nFreq: ${MIN_MHZ}-${MAX_MHZ} MHz\nTLP: $TLP_STATUS" -t 4000 -u normal
fi
