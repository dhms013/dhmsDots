---------------------
--- LOOK AND FEEL ---
---------------------

hl.config({
	general = {
		gaps_in = 1,
		gaps_out = 0.3,
		border_size = 3,
		resize_on_border = true,
		extend_border_grab_area = 15,
		allow_tearing = false,
		layout = "scrolling",
	},

	decoration = {
		-- rounding = 10,
		-- rounding_power = 2,
		active_opacity = 1,
		inactive_opacity = 0.8,
		fullscreen_opacity = 1,

		shadow = {
			enabled = true,
			range = 15,
			render_power = 3,
			color = "rgba(1a1a1a99)",
		},
	},

	dwindle = {
		preserve_split = true,
		force_split = 2,
	},

	scrolling = {
		column_width = 0.85,
		fullscreen_on_one_column = true,
	},

	animations = {
		enabled = true,
	},
})

hl.curve("float", { type = "bezier", points = { { 0.22, 0.9 }, { 0.2, 1.0 } } })
hl.curve("drift", { type = "bezier", points = { { 0.3, 1.05 }, { 0.38, 1.0 } } })
hl.curve("glassFade", { type = "bezier", points = { { 0.18, 0.0 }, { 0.12, 1.0 } } })
hl.curve("workspaceGlide", { type = "bezier", points = { { 0.23, 0.84 }, { 0.34, 1.0 } } })

hl.animation({
	leaf = "windows",
	enabled = true,
	speed = 3,
	bezier = "float",
})
hl.animation({
	leaf = "windowsIn",
	enabled = true,
	speed = 3,
	bezier = "drift",
	style = "popin 10%",
})
hl.animation({
	leaf = "windowsOut",
	enabled = true,
	speed = 3,
	bezier = "glassFade",
	style = "popin 82%",
})
hl.animation({
	leaf = "windowsMove",
	enabled = true,
	speed = 3,
	bezier = "float",
})
hl.animation({
	leaf = "border",
	enabled = true,
	speed = 3,
	bezier = "glassFade",
})
hl.animation({
	leaf = "fade",
	enabled = true,
	speed = 3,
	bezier = "glassFade",
})
hl.animation({
	leaf = "layers",
	enabled = true,
	speed = 3,
	bezier = "drift",
	style = "slidefade",
})
hl.animation({
	leaf = "layersIn",
	enabled = true,
	speed = 3,
	bezier = "drift",
	style = "slidefade",
})
hl.animation({
	leaf = "layersOut",
	enabled = true,
	speed = 3,
	bezier = "glassFade",
	style = "fade",
})
hl.animation({
	leaf = "workspaces",
	enabled = true,
	speed = 3,
	bezier = "workspaceGlide",
	style = "slide",
})
