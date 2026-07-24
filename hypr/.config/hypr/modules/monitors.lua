--  __  __             _
-- |  \/  | ___  _ __ (_) |_ ___  _ __ ___
-- | |\/| |/ _ \| '_ \| | __/ _ \| '__/ __|
-- | |  | | (_) | | | | | || (_) | |  \__ \
-- |_|  |_|\___/|_| |_|_|\__\___/|_|  |___/
-- Docked Mode

hl.monitor({
	output = "eDP-1",
	mode = "preferred",
	position = "0x0",
	scale = 1.57,
})

hl.monitor({
	output = "DP-3",
	mode = "1920x1080@75",
	position = "1920x0",
	scale = 1,
})

hl.config({
	xwayland = {
		force_zero_scaling = true,
	},
})

for i = 1, 10 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = "DP-3",
	})
end

for i = 11, 20 do
	hl.workspace_rule({
		workspace = tostring(i),
		monitor = "eDP-1",
	})
end
