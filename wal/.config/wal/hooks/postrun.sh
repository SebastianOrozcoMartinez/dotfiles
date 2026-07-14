#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Wallpaper
if [ -n "$1" ]; then
  awww img "$1" \
    --transition-type=wipe \
    --transition-duration=2 \
    --transition-fps=144 \
    --transition-step=30

  cp "$1" "$HOME/Pictures/Wallpapers/wallpaper.png"
fi

# SwayNC
pkill swaync || true
swaync &

# OpenRGB
COLOR=$(jq -r '.colors.color3' ~/.cache/wal/colors.json | sed 's/^#//')

openrgb \
  --device 0 \
  --mode "Keystroke Dim" \
  --speed 0 \
  --color "$COLOR"

# Obsidian
"$SCRIPT_DIR/obsidian.sh"
