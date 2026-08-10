--  ____        _
-- |  _ \ _   _| | ___  ___
-- | |_) | | | | |/ _ \/ __|
-- |  _ <| |_| | |  __/\__ \
-- |_| \_\\__,_|_|\___||___/
-- .lua

--------------------------------------------------
-- Layer Rules
--------------------------------------------------

hl.layer_rule({
	name = "swaync-control-center",
	match = {
		namespace = "swaync-control-center",
	},

	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "swaync-notification-window",
	match = {
		namespace = "swaync-notification-window",
	},

	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "rofi",
	match = {
		namespace = "rofi",
	},

	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "waybar",
	match = {
		namespace = "waybar",
	},

	blur = true,
	ignore_alpha = 0.5,
})

hl.layer_rule({
	name = "selection",
	match = {
		namespace = "selection",
	},

	no_anim = true,
})

hl.layer_rule({
	name = "rofi-animation",
	match = {
		namespace = "rofi",
	},

	animation = "popin",
})

hl.layer_rule({
	name = "quickshell",
	match = {
		namespace = "quickshell",
	},

	blur = true,
	blur_popups = true,
	ignore_alpha = 0.5,
})

--------------------------------------------------
-- Window Rules
--------------------------------------------------

hl.window_rule({
	name = "zen-pip",

	match = {
		title = "^(Picture-in-Picture)$",
		class = "^(zen)$",
	},

	float = true,
	pin = true,

	size = "640 360",

	keep_aspect_ratio = true,
})

hl.window_rule({
	name = "glass",

	match = {
		class = "^("
			.. "org.gnome.Nautilus"
			.. "|io.github.kaii_lb.Overskride"
			.. "|org.pulseaudio.pavucontrol"
			.. "|org.gnome.Calendar"
			.. "|org.gnome.Contacts"
			.. ")$",
	},

	opacity = 0.85,
})
