--     _         _            _             _
--    / \  _   _| |_ ___  ___| |_ __ _ _ __| |_
--   / _ \| | | | __/ _ \/ __| __/ _` | '__| __|
--  / ___ \ |_| | || (_) \__ \ || (_| | |  | |_
-- /_/   \_\__,_|\__\___/|___/\__\__,_|_|   \__|

hl.on("hyprland.start", function()
	-- env
	hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

	-- Battery management
	hl.exec_cmd("~/.local/bin/power-auto")

	hl.exec_cmd("hyprsunset &")
	hl.exec_cmd("awww-daemon &")
	hl.exec_cmd("blueman-applet &")
	hl.exec_cmd("openrgb --server &")
	hl.exec_cmd("signal-desktop &")
	hl.exec_cmd("vesktop --start-minimized &")
	hl.exec_cmd("zapzap &")
	hl.exec_cmd("kdeconnect-indicator &")
	hl.exec_cmd("localsend &")
	hl.exec_cmd("qs &")
end)

hl.env("xcursor_size", "24")
hl.env("hyprcursor_size", "24")
