#!/usr/bin/env fish

# Pywal color paths
set colors_json ~/.cache/wal/colors.json
set wallpaper (cat ~/.cache/wal/wal)

# Read pywal colors
set color0 (jq -r '.colors.color0' $colors_json)
set color1 (jq -r '.colors.color1' $colors_json)
set color2 (jq -r '.colors.color2' $colors_json)
set color3 (jq -r '.colors.color3' $colors_json)

# Load template
set template ~/.config/hypr/hyprlock.template
set output ~/.config/hypr/hyprlock.conf

# Replace placeholders
cat $template | sed "s|@WALLPATH@|$wallpaper|g" | sed "s|@COLOR0@|$color0|g" | sed "s|@COLOR1@|$color1|g" | sed "s|@COLOR2@|$color2|g" | sed "s|@COLOR3@|$color3|g" >$output
