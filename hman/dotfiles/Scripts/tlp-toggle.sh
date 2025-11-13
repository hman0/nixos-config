#!/usr/bin/env bash
# Script to toggle between TLP Battery Saving mode and Gaming mode (Thinkpad X13s)

STATE_FILE="/tmp/tlp_gaming_mode"

apply_gaming_settings() {
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "performance" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        if [ -f "$cpu" ]; then
            echo "performance" | doas tee "$cpu" > /dev/null 2>&1
        fi
    done
    
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
        echo "1200000" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
        echo "3000000" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        echo "0" | doas tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1
    fi
    if [ -f /sys/devices/system/cpu/cpufreq/boost ]; then
        echo "1" | doas tee /sys/devices/system/cpu/cpufreq/boost > /dev/null 2>&1
    fi
    
    if [ -f /sys/firmware/acpi/platform_profile ]; then
        echo "performance" | doas tee /sys/firmware/acpi/platform_profile > /dev/null 2>&1
    fi
    
    for device in /sys/bus/pci/devices/*/power/control; do
        echo "on" | doas tee "$device" > /dev/null 2>&1
    done
    
    if [ -f /sys/module/pcie_aspm/parameters/policy ]; then
        echo "performance" | doas tee /sys/module/pcie_aspm/parameters/policy > /dev/null 2>&1
    fi
    
    for device in /sys/bus/usb/devices/*/power/autosuspend; do
        echo "-1" | doas tee "$device" > /dev/null 2>&1
    done
}

if [ -f "$STATE_FILE" ]; then
    MODE="battery"
    notify-send "TLP Mode" "Switching to Battery Optimization" -t 3000 -u normal
else
    MODE="gaming"
    notify-send "TLP Mode" "Switching to Gaming Performance" -t 3000 -u normal
fi

if [ "$MODE" = "gaming" ]; then
    if [ -f /tmp/tlp_gaming_monitor.pid ]; then
        OLD_PID=$(cat /tmp/tlp_gaming_monitor.pid)
        if kill -0 "$OLD_PID" 2>/dev/null; then
            kill "$OLD_PID" 2>/dev/null
        fi
        rm -f /tmp/tlp_gaming_monitor.pid
    fi
    
    doas pkill -9 tlp
    doas systemctl stop tlp.service 2>/dev/null
    
    apply_gaming_settings
    
    touch "$STATE_FILE"
    
    (
        LAST_GOV=""
        while [ -f "$STATE_FILE" ]; do
            CURRENT_GOV=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null)
            if [ "$CURRENT_GOV" != "performance" ] && [ "$CURRENT_GOV" != "$LAST_GOV" ]; then
                apply_gaming_settings
                LAST_GOV="$CURRENT_GOV"
            fi
            sleep 2
        done
    ) &
    echo $! > /tmp/tlp_gaming_monitor.pid
    
else
    rm -f "$STATE_FILE"
    
    if [ -f /tmp/tlp_gaming_monitor.pid ]; then
        kill $(cat /tmp/tlp_gaming_monitor.pid) 2>/dev/null
        rm -f /tmp/tlp_gaming_monitor.pid
    fi
    
    doas systemctl restart tlp.service
fi

sleep 0.5
GOVERNOR=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo "unknown")
MIN_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq 2>/dev/null || echo "0")
MAX_FREQ=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq 2>/dev/null || echo "0")
MIN_MHZ=$((MIN_FREQ / 1000))
MAX_MHZ=$((MAX_FREQ / 1000))
TLP_STATUS=$(systemctl is-active tlp.service 2>/dev/null || "inactive")

if [ "$MODE" = "gaming" ]; then
    notify-send "Gaming Performance Mode" "CPU: $GOVERNOR\nFreq: ${MIN_MHZ}-${MAX_MHZ} MHz\nTLP: $TLP_STATUS" -t 4000 -u normal
else
    notify-send "Battery Optimization Mode" "CPU: $GOVERNOR\nFreq: ${MIN_MHZ}-${MAX_MHZ} MHz\nTLP: $TLP_STATUS" -t 4000 -u normal
fi
