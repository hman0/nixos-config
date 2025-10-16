#!/usr/bin/env bash

monitor=$1

file=~/Pictures/Screenshots/Screenshot_$(date +%Y-%m-%d_%H-%M-%S).png

grim -o "$monitor" "$file" && \
wl-copy < "$file" && \
notify-send -i "$file" "Screenshot captured" "You can paste the image from the clipboard."
