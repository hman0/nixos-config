#!/usr/bin/env bash
# Script to take screenshots and convert it to JPEG, for small file size
# Usage: screenshot-jpeg.sh [selection|screen|window]

MODE="${1:-screen}"
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TEMP_PNG="/tmp/screenshot_temp_$.png"
FINAL_JPEG="$SCREENSHOT_DIR/Screenshot from $(date +"%Y-%m-%d %H-%M-%S").jpg"

mkdir -p "$SCREENSHOT_DIR"

# Take screenshot based on mode
case "$MODE" in
  selection)
    grim -g "$(slurp)" "$TEMP_PNG" || exit 1
    ;;
  screen)
    grim "$TEMP_PNG" || exit 1
    ;;
  window)
    # Get focused window geometry from niri
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

# Convert to JPEG with web optimization and copy to clipboard
# -quality 85: Good balance between quality and file size
# -sampling-factor 4:2:0: Standard chroma subsampling
# -strip: Remove metadata
# -interlace Plane: Progressive JPEG for web
magick "$TEMP_PNG" \
  -quality 85 \
  -sampling-factor 4:2:0 \
  -strip \
  -interlace Plane \
  "$FINAL_JPEG"

echo "Saved to: $FINAL_JPEG"

# Copy to clipboard as image data (not file path)
echo "Copying to clipboard..."
echo -n "file://$FINAL_JPEG" | wl-copy --type text/uri-list

if [ $? -eq 0 ]; then
  echo "Successfully copied to clipboard"
else
  echo "Failed to copy to clipboard, exit code: $?"
fi

# Remove temporary PNG
rm "$TEMP_PNG"

# Show notification
notify-send "Screenshot saved & copied" "$(basename "$FINAL_JPEG")"
