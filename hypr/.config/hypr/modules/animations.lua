--     _          _                 _   _
--    / \   _ __ (_)_ __ ___   __ _| |_(_) ___  _ __  ___
--   / _ \ | '_ \| | '_ ` _ \ / _` | __| |/ _ \| '_ \/ __|
--  / ___ \| | | | | | | | | | (_| | |_| | (_) | | | \__ \
-- /_/   \_\_| |_|_|_| |_| |_|\__,_|\__|_|\___/|_| |_|___/
-- .lua

hl.config({
	animations = {
		enabled = true,
	},
})

-- Custom bezier curves for smoother motion
hl.curve("wind", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("winIn", { type = "bezier", points = { { 0.1, 1.1 }, { 0.1, 1.1 } } })
hl.curve("winOut", { type = "bezier", points = { { 0.3, -0.3 }, { 0, 1 } } })
hl.curve("liner", { type = "bezier", points = { { 1, 1 }, { 1, 1 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })
hl.curve("smoothOut", { type = "bezier", points = { { 0.36, 0 }, { 0.66, -0.56 } } })
hl.curve("smoothIn", { type = "bezier", points = { { 0.25, 1 }, { 0.5, 1 } } })

-- Enhanced window animations
hl.animation({ leaf = "windows", enabled = true, speed = 6, bezier = "wind", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "default", style = "popin" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 6, bezier = "default", style = "popin 20%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, bezier = "wind", style = "slide" })

-- Workspace animations
hl.animation({ leaf = "workspaces", enabled = true, speed = 5, bezier = "wind" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 6, bezier = "wind", style = "slidevert" })

-- UI element animations
hl.animation({ leaf = "fade", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "default", style = "slide" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 10, bezier = "default", style = "popin 30%" })
