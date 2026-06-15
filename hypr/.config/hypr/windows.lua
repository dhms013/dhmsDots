--------------------
--- WINDOW RULES ---
--------------------

-- Fullscreen windows
hl.window_rule({
	name = "fullscreen",
	match = { class = ".*" },
	idle_inhibit = "fullscreen",
})

-- Suppress maximize event
hl.window_rule({
	name = "suppress-maximize",
	match = { class = ".*" },
	suppress_event = "maximize",
})

-- No focus for empty xwayland floating windows
hl.window_rule({
	name = "no-focus-empty",
	match = {
		class = "^$",
		title = "^$",
		xwayland = true,
		float = true,
		fullscreen = false,
		pin = false,
	},
	no_focus = true,
})

-- Zen Browser
hl.window_rule({
	name = "zen-browser",
	match = { class = "^(zen)$" },
	opacity = "1 override",
})

-- Chromium
hl.window_rule({
	name = "chromium",
	match = { class = "^(chromium)$" },
	opacity = "1 override",
})

-- VS code
hl.window_rule({
	name = "vs code",
	match = { class = "^(code)$" },
	opacity = "1 override",
})

-- Postman
hl.window_rule({
	name = "postman",
	match = { class = "^(Postman)$" },
	opacity = "1 override",
})

-- Neovim
hl.window_rule({
	name = "nvim",
	match = { title = "^(nvim)$" },
	opacity = "1 override",
})

-- Steam
hl.window_rule({
	name = "Steam",
	match = { title = "^(Steam)$" },
	opacity = "1 override",
	idle_inhibit = "focus",
})

-- Where Winds Meet
hl.window_rule({
	name = "where-winds-meet",
	match = { title = "^(Where Winds Meet)$" },
	opacity = "1 override",
	idle_inhibit = "focus",
})

-- Image Viewer (imv)
hl.window_rule({
	name = "imv",
	match = { class = "^(imv)$" },
	float = true,
	stay_focused = true,
	center = true,
})

-- MPV Player
hl.window_rule({
	name = "mpv",
	match = { class = "^(mpv)$" },
	float = true,
	stay_focused = true,
	center = true,
	opacity = "1 override",
})

-- DHMS Terminal
hl.window_rule({
	name = "dhms-terminal",
	match = { class = "^(dhms\\.terminal)$" },
	float = true,
	stay_focused = true,
	center = true,
	idle_inhibit = "focus",
	size = { 600, 400 },
})

-- Satty Screenshot Tool
hl.window_rule({
	name = "satty",
	match = { class = "^(com\\.gabm\\.satty)$" },
	float = true,
	stay_focused = true,
	center = true,
	size = { 700, 500 },
})

-- ============================
-- MISC SETTINGS
-- ============================

hl.config({
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		allow_session_lock_restore = true,
		on_focus_under_fullscreen = true,
	},
})
