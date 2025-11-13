#!/usr/bin/env bash
# Script to print battery information to notifications

battery_info=$(acpi -b)

if [ -z "$battery_info" ]; then
    notify-send "Battery" "No battery information available" -u normal
    exit 1
fi

percentage=$(echo "$battery_info" | grep -oP '\d+(?=%)')
state=$(echo "$battery_info" | grep -oP '(Charging|Discharging|Full|Unknown)' | head -1)
time_remaining=$(echo "$battery_info" | grep -oP '\d{2}:\d{2}:\d{2}' | head -1)

if [ "$state" = "Charging" ]; then
    urgency="normal"
    icon="battery-charging"
    title="Battery Charging"
elif [ "$state" = "Full" ]; then
    urgency="low"
    icon="battery-full-charged"
    title="Battery Full"
elif [ "$percentage" -le 10 ]; then
    urgency="critical"
    icon="battery-empty"
    title="Battery Critical"
elif [ "$percentage" -le 20 ]; then
    urgency="critical"
    icon="battery-caution"
    title="Battery Low"
else
    urgency="normal"
    icon="battery-good"
    title="Battery Status"
fi

message="Level: ${percentage}%"
if [ -n "$time_remaining" ]; then
    if [ "$state" = "Charging" ]; then
        message="${message}\nTime until full: ${time_remaining}"
    elif [ "$state" = "Discharging" ]; then
        message="${message}\nTime remaining: ${time_remaining}"
    fi
fi

notify-send "$title" "$message" -u "$urgency" -i "$icon" -t 5000
