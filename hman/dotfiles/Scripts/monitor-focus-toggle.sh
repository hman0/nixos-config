#!/bin/sh

current_output=$(niri msg focused-output | grep -o "DP-[0-9]")

if [ "$current_output" = "DP-5" ]; then # Iiyama to Samsung
    niri msg action focus-monitor-down
elif [ "$current_output" = "DP-4" ]; then # Samsung to Iiyama
    niri msg action focus-monitor-up
else
    echo "Monitor focus toggle failed!"
fi
