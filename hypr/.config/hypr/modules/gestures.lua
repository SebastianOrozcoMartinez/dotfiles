--   ____           _
--  / ___| ___  ___| |_ _   _ _ __ ___  ___
-- | |  _ / _ \/ __| __| | | | '__/ _ \/ __|
-- | |_| |  __/\__ \ |_| |_| | | |  __/\__ \
--  \____|\___||___/\__|\__,_|_|  \___||___/

-- local ha = require("modules.ha")
-- Swaync
local notidown = function()
	hl.exec_cmd("swaync-client -cp")
end
local notifitog = function()
	hl.exec_cmd("swaync-client -t")
end
hl.gesture({
	fingers = 3,
	direction = "up",
	action = notifitog,
})
hl.gesture({
	fingers = 3,
	direction = "down",
	action = notidown,
})

-- Workspaces
-- Workspace navigation
-- Workspace navigation
hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.gesture({
	fingers = 3,
	direction = "pinch",
	action = "cursor_zoom",
	zoom_level = 1,
	mode = "live",
})

hl.gesture({
	fingers = 4,
	direction = "down",
	mods = "SUPER",
	action = "special",
	workspace_name = "scratchpad",
})

hl.gesture({
	fingers = 3,
	direction = "up",
	mods = "SUPER",
	action = "fullscreen",
})
