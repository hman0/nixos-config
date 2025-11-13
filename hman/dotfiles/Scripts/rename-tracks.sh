#!/usr/bin/env bash
# Script to auto rename song filenames for my song library

read -rp "Enter artist name: " artist
[[ -z "$artist" ]] && { echo ""; exit 1; }

shopt -s nullglob
files=( *.mp3 *.flac *.lrc )
shopt -u nullglob

if [ ${#files[@]} -eq 0 ]; then
  echo "No .mp3 or .flac or .lrc files found."
  exit 1
fi

if [ ${#files[@]} -eq 1 ] || { [ ${#files[@]} -eq 2 ] && [[ ${files[0]%.*} == ${files[1]%.*} ]]; }; then
  for f in "${files[@]}"; do
    ext="${f##*.}"
    title=$(echo "$f" | sed -E 's/\.[^.]+$//')
    new="01 - $artist - $title.$ext"
    echo "Renaming \"$f\" → \"$new\""
    mv -i -- "$f" "$new"
  done
  echo "Complete"
  exit 0
fi

for f in "${files[@]}"; do
  [[ "$f" == "cover.jpg" ]] && continue
  [[ -f "$f" ]] || continue

  base="${f%.*}"
  num=$(echo "$base" | grep -oE '^[0-9]+')
  title=$(echo "$base" | sed -E 's/^[0-9]+[[:punct:]]?[[:space:]]*//')
  ext="${f##*.}"

  if [[ -z "$num" ]]; then
    num="01"
  else
    num=$(printf "%02d" $((10#$num)))
  fi

  new=$(printf "%s - %s - %s.%s" "$num" "$artist" "$title" "$ext")
  echo "Renaming \"$f\" → \"$new\""
  mv -i -- "$f" "$new"
done

echo "Complete"
