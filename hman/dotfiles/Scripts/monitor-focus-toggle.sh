#!/bin/sh
# Script to quickly toggle focus between my monitors

current_output=$(niri msg focused-output | grep -o "DP-[0-9]")

if [ "$current_output" = "DP-2" ]; then # Iiyama to Samsung
    niri msg action focus-monitor-down
elif [ "$current_output" = "DP-1" ]; then # Samsung to Iiyama
    niri msg action focus-monitor-up
else
    echo "Monitor focus toggle failed!"
fi
