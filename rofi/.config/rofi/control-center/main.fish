#!/usr/bin/env fish

set choice (printf "%s\n" \
    "󰣇 Control Center" \
    "󰸉 Wallpapers" \
    "󰀻 Appearance" \
    "󰖩 Network" \
    "󰕾 Audio" \
    "󰒓 System" \
    "󰲋 Developer" \
    | rofi -dmenu -i -p "Settings")

switch $choice

    case "󰸉 Wallpapers"
        ~/.config/rofi/control-center/menus/wallpaper.fish

    case "󰀻 Appearance"
        ~/.config/rofi/control-center/menus/appearance.fish

    case "󰖩 Network"
        ~/.config/rofi/control-center/menus/network.fish

    case "󰕾 Audio"
        ~/.config/rofi/control-center/menus/audio.fish

    case "󰒓 System"
        ~/.config/rofi/control-center/menus/system.fish

    case "󰲋 Developer"
        ~/.config/rofi/control-center/menus/developer.fish
end
