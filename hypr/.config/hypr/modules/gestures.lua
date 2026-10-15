--   ____           _
--  / ___| ___  ___| |_ _   _ _ __ ___  ___
-- | |  _ / _ \/ __| __| | | | '__/ _ \/ __|
-- | |_| |  __/\__ \ |_| |_| | | |  __/\__ \
--  \____|\___||___/\__|\__,_|_|  \___||___/

local ha = require("modules.ha")

local lock = function()
	hl.exec_cmd("hyprlock")
end

local toggle_lights = function()
	ha.ha_service("light", "toggle", [[{"entity_id":"light.luz_1"}]])
	ha.ha_service("light", "toggle", [[{"entity_id":"light.luz_2"}]])
end

hl.gesture({
	fingers = 4,
	direction = "up",
	action = lock,
})

hl.gesture({
	fingers = 4,
	direction = "down",
	action = toggle_lights,
})
