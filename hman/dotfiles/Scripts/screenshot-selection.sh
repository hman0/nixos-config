#!/usr/bin/env bash
# Script to screenshot a selection

file=~/Pictures/Screenshots/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png

grim -g "$(slurp)" "$file" && \
wl-copy < "$file" && \
notify-send -i "$file" "Screenshot captured" "You can paste the image from the clipboard."
