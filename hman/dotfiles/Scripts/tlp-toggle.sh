#!/usr/bin/env bash

# TLP Gaming Mode Toggle Script for NixOS
# Directly modifies CPU and power settings at runtime

STATE_FILE="/tmp/tlp_gaming_mode"

apply_gaming_settings() {
    # Set CPU governor to performance on all cores
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
        echo "performance" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Set energy performance preference to performance
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference; do
        if [ -f "$cpu" ]; then
            echo "performance" | doas tee "$cpu" > /dev/null 2>&1
        fi
    done
    
    # Set CPU minimum frequency to higher value (1.2 GHz)
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq; do
        echo "1200000" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Set CPU maximum frequency to max (3.0 GHz)
    for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq; do
        echo "3000000" | doas tee "$cpu" > /dev/null 2>&1
    done
    
    # Enable CPU turbo boost
    if [ -f /sys/devices/system/cpu/intel_pstate/no_turbo ]; then
        echo "0" | doas tee /sys/devices/system/cpu/intel_pstate/no_turbo > /dev/null 2>&1
    fi
    if [ -f /sys/devices/system/cpu/cpufreq/boost ]; then
        echo "1" | doas tee /sys/devices/system/cpu/cpufreq/boost > /dev/null 2>&1
    fi
    
    # Set platform profile to performance
    if [ -f /sys/firmware/acpi/platform_profile ]; then
        echo "performance" | doas tee /sys/firmware/acpi/platform_profile > /dev/null 2>&1
    fi
    
    # Disable runtime PM for PCI devices (including GPU)
    for device in /sys/bus/pci/devices/*/power/control; do
        echo "on" | doas tee "$device" > /dev/null 2>&1
    done
    
    # Set PCIe ASPM to performance (disable power saving)
    if [ -f /sys/module/pcie_aspm/parameters/policy ]; then
        echo "performance" | doas tee /sys/module/pcie_aspm/parameters/policy > /dev/null 2>&1
    fi
    
    # Disable USB autosuspend
    for device in /sys/bus/usb/devices/*/power/autosuspend; do
        echo "-1" | doas tee "$device" > /dev/null 2>&1
    done
}

# Check if gaming mode is currently active
if [ -f "$STATE_FILE" ]; then
    MODE="battery"
    notify-send "TLP Mode" "Switching to Battery Optimization" -t 3000 -u normal
else
    MODE="gaming"
    notify-send "TLP Mode" "Switching to Gaming Performance" -t 3000 -u normal
fi

if [ "$MODE" = "gaming" ]; then
    # GAMING MODE - Maximum Performance
    
    # Kill any existing monitor process first to prevent stacking
    if [ -f /tmp/tlp_gaming_monitor.pid ]; then
        OLD_PID=$(cat /tmp/tlp_gaming_monitor.pid)
        if kill -0 "$OLD_PID" 2>/dev/null; then
            kill "$OLD_PID" 2>/dev/null
        fi
        rm -f /tmp/tlp_gaming_monitor.pid
    fi
    
    # Kill TLP process directly and prevent restart
    doas pkill -9 tlp
    doas systemctl stop tlp.service 2>/dev/null
    
    # Apply gaming settings
    apply_gaming_settings
    
    # Mark gaming mode as active
    touch "$STATE_FILE"
    
    # Create a simple monitor that reapplies settings only if governor changes
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
    # BATTERY MODE - Restore TLP management
    
    # Remove gaming mode marker
    rm -f "$STATE_FILE"
    
    # Kill the monitor process
    if [ -f /tmp/tlp_gaming_monitor.pid ]; then
        kill $(cat /tmp/tlp_gaming_monitor.pid) 2>/dev/null
        rm -f /tmp/tlp_gaming_monitor.pid
    fi
    
    # Restart TLP service
    doas systemctl restart tlp.service
fi

# Show current status
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
