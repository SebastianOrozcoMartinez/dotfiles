#!/usr/bin/env fish

set choice (printf "%s\n" \
    "󰖩 WiFi" \
    "󰩠 Tailscale" \
    "󰌌 Bluetooth" \
    "󰁍 Back" \
    | rofi -dmenu -p "Network")

switch $choice

    case "󰖩 WiFi"
        ~/scripts/rofi-wifi-menu.sh

    case "󰩠 Tailscale"
        ~/.config/rofi/control-center/menus/tailscale.fish

    case "󰌌 Bluetooth"
        overskride

    case "󰁍 Back"
        ~/.config/rofi/control-center/main.fish
end
