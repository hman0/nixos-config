#!/usr/bin/env bash

BROWSER="librewolf"
bookmarks=(
  "  Media|FOLDER|"
  "  YouTube|https://youtube.com|Media"
  "  Odysee|https://odysee.com|Media"
  "  Spotify|https://open.spotify.com|Media"
  "  Communication|FOLDER|"
  "  Discord|https://discord.com/app|Communication"
  "  Development|FOLDER|"
  "  GitHub - hman0|https://github.com/hman0|Development"
  "  Wiki|FOLDER|"
  "  FMHY|https://fmhy.net|Wiki"
  "  Gentoo|https://wiki.gentoo.org|Wiki"
  "  Arch Linux|https://wiki.archlinux.org|Wiki"
  "  NixOS|https://wiki.nixos.org|Wiki"
  "  Games|FOLDER|"
  "  Isaacle|https://isaacle.net|Games"
  "  Server|FOLDER|"
  "  Homepage|http://192.168.0.169:3000|Server"
  "  Syncthing - localhost|https://127.0.0.1:8384|Server"
  "  Syncthing - libreshimi|https://192.168.0.169:8384|Server"
  "  Jellyfin|http://192.168.0.169:8096|Server"
)
show_menu() {
  local current_folder="$1"
  local menu_items=()
  
  if [ -n "$current_folder" ]; then
    menu_items+=("<- Back")
  fi
  
  for bookmark in "${bookmarks[@]}"; do
    IFS='|' read -r name url folder <<< "$bookmark"
    
    if [ -z "$current_folder" ] && [ -z "$folder" ]; then
      menu_items+=("$name")
    elif [ "$folder" = "$current_folder" ]; then
      menu_items+=("$name")
    fi
  done
  
  printf '%s\n' "${menu_items[@]}" | fuzzel --dmenu --prompt="Bookmarks: "
}
open_url() {
  local url="$1"
  "$BROWSER" "$url" &
}
current_folder=""
while true; do
  selection=$(show_menu "$current_folder")
  
  [ -z "$selection" ] && exit 0
  
  if [ "$selection" = "<- Back" ]; then
    current_folder=""
    continue
  fi
  
  found=false
  for bookmark in "${bookmarks[@]}"; do
    IFS='|' read -r name url folder <<< "$bookmark"
    
    if [ "$name" = "$selection" ]; then
      found=true
      if [ "$url" = "FOLDER" ]; then
        current_folder="${name#  }"
        current_folder="${current_folder# }"
        break
      else
        open_url "$url"
        exit 0
      fi
    fi
  done
  
  if [ "$found" = false ]; then
    exit 0
  fi
done
