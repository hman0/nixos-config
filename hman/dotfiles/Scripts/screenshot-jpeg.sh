#!/usr/bin/env bash
# Script to screenshot and convert to JPEG
# Usage: screenshot-jpeg.sh [selection|screen|window]

MODE="${1:-screen}"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TEMP_PNG="/tmp/screenshot_temp_$$.png"
FINAL_JPEG="$SCREENSHOT_DIR/Screenshot from $(date +"%Y-%m-%d %H-%M-%S").jpg"

mkdir -p "$SCREENSHOT_DIR"

freeze_and_slurp() {
  TMPSS="/tmp/freeze_screen_$$.png"
  grim "$TMPSS"
  imv -f "$TMPSS" &
  IMV_PID=$!
  GEOM=$(slurp)
  kill "$IMV_PID"
  rm "$TMPSS"
  echo "$GEOM"
}

case "$MODE" in
  selection)
    GEOM=$(freeze_and_slurp)
    if [ -z "$GEOM" ]; then
      notify-send "Screenshot failed" "No selection made"
      exit 1
    fi
    grim -g "$GEOM" "$TEMP_PNG" || exit 1
    ;;
  screen)
    grim "$TEMP_PNG" || exit 1
    ;;
  window)
    GEOMETRY=$(niri msg focused-window | jq -r '"\(.x),\(.y) \(.width)x\(.height)"')
    if [ -n "$GEOMETRY" ]; then
      grim -g "$GEOMETRY" "$TEMP_PNG" || exit 1
    else
      notify-send "Screenshot failed" "No focused window"
      exit 1
    fi
    ;;
  *)
    echo "Usage: $0 [selection|screen|window]"
    exit 1
    ;;
esac

magick "$TEMP_PNG" \
  -quality 90 \
  -sampling-factor 4:2:0 \
  -strip \
  -interlace Plane \
  "$FINAL_JPEG"

echo "Saved to: $FINAL_JPEG"

echo "Copying to clipboard..."
echo -n "file://$FINAL_JPEG" | wl-copy --type text/uri-list

if [ $? -eq 0 ]; then
  echo "Successfully copied to clipboard"
else
  echo "Failed to copy to clipboard, exit code: $?"
fi

rm "$TEMP_PNG"

notify-send "Screenshot saved & copied" "$(basename "$FINAL_JPEG")"

