#!/bin/bash
# Spotify-only module for Waybar

PLAYER="spotify"

status=$(playerctl --player=$PLAYER status 2>/dev/null)

if [ "$status" = "Playing" ]; then
  title=$(playerctl --player=$PLAYER metadata title | cut -c1-30)
  echo "󰓇 $title"
elif [ "$status" = "Paused" ]; then
  echo "󰓇 Paused"
else
  echo "󰓇 Spotify"
fi
