#!/usr/bin/env bash

count=$(hyprctl clients -j |
  jq '[.[] | select(.class == "discord" and .urgent == true)] | length')

if [ "$count" -eq 0 ]; then
  echo ""
else
  echo " $count"
fi
