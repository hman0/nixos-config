#!/usr/bin/env bash
read -rp "Enter artist name: " artist
[[ -z "$artist" ]] && { echo ""; exit 1; }

files=(*.mp3 *.flac *.lrc)
files=( "${files[@]}" ) 

shopt -s nullglob
files=( "${files[@]}" )
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
  echo "No .mp3 or .flac or .lrc files found."
  exit 1
fi

if [ ${#files[@]} -eq 1 ]; then
  f="${files[0]}"
  ext="${f##*.}"
  title=$(echo "$f" | sed -E 's/^[0-9]+\. *//; s/\.[^.]+$//')
  new="01 - $artist - $title.$ext"
  echo "Renaming \"$f\" → \"$new\""
  mv -i -- "$f" "$new"
  exit 0
fi

for f in "${files[@]}"; do
  [[ "$f" == "cover.jpg" ]] && continue
  [[ -f "$f" ]] || continue

  num=$(echo "$f" | cut -d'.' -f1)
  title=$(echo "$f" | cut -d'.' -f2- | sed -E 's/^ *//; s/\.[^.]+$//')
  ext="${f##*.}"

  new=$(printf "%s - %s - %s.%s" "$num" "$artist" "$title" "$ext")
  echo "Renaming \"$f\" → \"$new\""
  mv -i -- "$f" "$new"
done

echo "Complete"

