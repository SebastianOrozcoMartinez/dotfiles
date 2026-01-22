#!/bin/bash
# Spotify module for Waybar

status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
  artist=$(playerctl metadata artist 2>/dev/null)
  title=$(playerctl metadata title 2>/dev/null)
  echo "$artist - $title"
elif [ "$status" = "Paused" ]; then
  echo "Paused"
else
  echo "Spotify"
fi
