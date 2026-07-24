--     _
--    / \   _ __  _ __   ___  __ _ _ __ ___ _ __   ___ ___
--   / _ \ | '_ \| '_ \ / _ \/ _` | '__/ _ \ '_ \ / __/ _ \
--  / ___ \| |_) | |_) |  __/ (_| | | |  __/ | | | (_|  __/
-- /_/   \_\ .__/| .__/ \___|\__,_|_|  \___|_| |_|\___\___|
--         |_|   |_|
-- .lua

return {
	general = {
		gaps_in = 5,
		gaps_out = 20,
		border_size = 0,

		layout = "dwindle",
		resize_on_border = true,
		hover_icon_on_border = true,
		extend_border_grab_area = 20,
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,

		active_opacity = 1.0,
		inactive_opacity = 0.8,

		shadow = {
			enabled = true,
			range = 4,
			render_power = 3,
			color = 0x1a1a1aee,
		},

		blur = {
			enabled = true,
			size = 3,
			passes = 3,
			vibrancy = 0.1696,
		},
	},
}
