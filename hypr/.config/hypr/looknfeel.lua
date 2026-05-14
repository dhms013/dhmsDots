---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 1,
		border_size = 3,
		resize_on_border = true,
		extend_border_grab_area = 15,
		allow_tearing = false,
		layout = "dwindle",
	},

	decoration = {
		rounding = 10,
		rounding_power = 2,
		active_opacity = 0.8,
		inactive_opacity = 0.8,
		fullscreen_opacity = 1,

		shadow = {
			enabled = true,
			range = 15,
			render_power = 3,
			color = "rgba(1a1a1a99)",
			offset = { x = 0, y = 0 },
		},
	},

	dwindle = {
		preserve_split = true,
		force_split = 2,
	},

	scrolling = {
		fullscreen_on_one_column = true,
	},
})

hl.curve("village", {
	type = "bezier",
	points = { { 0.22, 1 }, { 0.36, 1 } },
})

hl.curve("borderEase", {
	type = "bezier",
	points = { { 0.22, 1 }, { 0.36, 1 } },
})

hl.curve("silk_drop", {
	type = "bezier",
	points = { { 0.28, 1.54 }, { 0.70, 1 } },
})

hl.animation({ leaf = "windows", enabled = true, speed = 5, curve = "village", style = "slide" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 5, curve = "village", style = "slide" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 4, curve = "village", style = "slide" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 5, curve = "village" })
hl.animation({ leaf = "fade", enabled = true, speed = 4, curve = "village" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 4, curve = "village" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, curve = "village" })
hl.animation({ leaf = "layers", enabled = true, speed = 4, curve = "village" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, curve = "village" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 3, curve = "village" })
hl.animation({ leaf = "border", enabled = true, speed = 6, curve = "borderEase" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2.2, curve = "silk_drop", style = "slidevert" })
