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
