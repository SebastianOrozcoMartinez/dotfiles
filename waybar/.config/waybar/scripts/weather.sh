#!/bin/bash

temp=$(curl -s 'wttr.in/?format=%t')
condition=$(curl -s 'wttr.in/?format=%C')

# Clean temperature
temp=$(echo "$temp" | tr -d '+C')

case "$condition" in
*sun* | *Sunny* | *Clear*)
  icon="󰖙"
  ;;
*cloud* | *Cloud*)
  icon="󰖐"
  ;;
*rain* | *Rain* | *drizzle*)
  icon="󰖗"
  ;;
*thunder*)
  icon="󰖓"
  ;;
*snow*)
  icon="󰼶"
  ;;
*fog* | *mist*)
  icon="󰖑"
  ;;
*)
  icon="󰖐"
  ;;
esac

echo "$icon  $temp"
