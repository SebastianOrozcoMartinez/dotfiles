#!/usr/bin/env fish

set choice (printf "%s\n" \
    "󰸉 Select Wallpaper" \
    "󰄬 Reload Wal" \
    "󰀻 Change Bar" \
    "󰁍 Back" \
    | rofi -dmenu -p "Wallpaper")

switch $choice
    case "󰸉 Select Wallpaper"
        ~/scripts/wal2/walmenu2.fish

    case "󰄬 Reload Wal"
        wal -R

    case "󰀻 Change Bar"
        ~/scripts/wal2/setbar.fish

    case "󰁍 Back"
        ~/.config/rofi/control-center/main.fish
end
