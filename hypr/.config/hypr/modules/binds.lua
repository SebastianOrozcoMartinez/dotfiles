--  ____  _           _
-- | __ )(_)_ __   __| |___
-- |  _ \| | '_ \ / _` / __|
-- | |_) | | | | | (_| \__ \
-- |____/|_|_| |_|\__,_|___/
-- .lua

local mainMod = "SUPER"
local ctrl = "CTRL"

local menu = "rofi -show drun"

local function bind(combo, dispatcher, opts)
	hl.bind(combo, dispatcher, opts)
end

local function exec(combo, cmd, opts)
	bind(combo, hl.dsp.exec_cmd(cmd), opts)
end

--------------------------------------------------
-- Applications
--------------------------------------------------

exec(mainMod .. " + Q", "kitty")
bind(mainMod .. " + C", hl.dsp.window.close())
bind(mainMod .. " + M", hl.dsp.exit())

exec(mainMod .. " + E", "nautilus")
bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))

exec("ALT + space", menu)
exec(mainMod .. " + Return", menu)

bind(mainMod .. " + P", hl.dsp.window.pseudo())

exec(mainMod .. " + SHIFT + L", "hyprlock")
exec(mainMod .. " + SHIFT + T", "udevadm trigger --subsystem-match=input --action=change")

exec(ctrl .. " + space", "~/.config/hypr/scripts/walmenu2.fish")

exec(mainMod .. " + W", "~/scripts/rofi-wifi-menu.sh")

exec(mainMod .. " + Print", "hyprshot -m region --clipboard-only")
exec(mainMod .. " + SHIFT + Print", "hyprpicker | wl-copy")

exec(mainMod .. " + F1", "~/.config/hypr/scripts/toggle_monitor_focus.sh")

--------------------------------------------------
-- Focus
--------------------------------------------------

bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

--------------------------------------------------
-- Workspaces
--------------------------------------------------

for i = 1, 10 do
	local key = i % 10

	bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))

	bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

for i = 11, 20 do
	local key = i - 10

	bind(mainMod .. " + F" .. key, hl.dsp.focus({ workspace = i }))

	bind(mainMod .. " + SHIFT + F" .. key, hl.dsp.window.move({ workspace = i }))
end

--------------------------------------------------
-- Mouse
--------------------------------------------------

bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })

bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------------------------------------
-- Volume
--------------------------------------------------

exec(
	"Control_R + Up",
	"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && ~/scripts/osd.sh",
	{ locked = true, repeating = true }
)

exec(
	"Control_R + Down",
	"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/scripts/osd.sh",
	{ locked = true, repeating = true }
)

exec(
	"XF86AudioRaiseVolume",
	"wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+ && ~/scripts/osd.sh",
	{ locked = true, repeating = true }
)

exec(
	"XF86AudioLowerVolume",
	"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && ~/scripts/osd.sh",
	{ locked = true, repeating = true }
)

exec("XF86AudioMute", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { locked = true, repeating = true })

exec("XF86AudioMicMute", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { locked = true, repeating = true })

--------------------------------------------------
-- Brightness
--------------------------------------------------

exec("XF86MonBrightnessUp", "brightnessctl -e4 -n2 set 5%+", { locked = true, repeating = true })

exec("XF86MonBrightnessDown", "brightnessctl -e4 -n2 set 5%-", { locked = true, repeating = true })

--------------------------------------------------
-- Spotify
--------------------------------------------------

exec("XF86AudioNext", "playerctl -p spotify next", { locked = true })

exec("XF86AudioPause", "playerctl -p spotify play-pause", { locked = true })

exec("XF86AudioPlay", "playerctl -p spotify play-pause", { locked = true })

exec("XF86AudioPrev", "playerctl -p spotify previous", { locked = true })

exec("Control_R + Right", "playerctl -p spotify next", { locked = true })

exec("Control_R + Pause", "playerctl -p spotify play-pause", { locked = true })

exec("Control_R + Left", "playerctl -p spotify previous", { locked = true })

--------------------------------------------------
-- Notifications
--------------------------------------------------

exec(mainMod .. " + N", "swaync-client -t")
exec(mainMod .. " + D", "swaync-client -d")

--------------------------------------------------
-- TODO (still Hyprlang)
--------------------------------------------------

-- bindl = , switch:on:Lid Switch, exec, hyprctl dispatch dpms off
-- bindl = , switch:off:Lid Switch, exec, hyprctl dispatch dpms on
--
-- The Lua example doesn't document switch device bindings yet.
