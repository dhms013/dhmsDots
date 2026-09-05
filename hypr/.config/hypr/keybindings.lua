---------------------
---- KEYBINDINGS ----
---------------------

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

local terminal = "uwsm-app -- ghostty"
local subTerminal = "uwsm-app -- kitty"
local fileManager = terminal .. " -e yazi"
local editor = terminal .. " --title=nvim -e nvim"
local browser = "uwsm-app -- brave-origin"
local subBrowser = "uwsm-app -- zen-browser"
local qs = "dhms-shell shell toggle"
local apps = qs .. ' dhms.menu \'{"menu":"apps"}\''
local menu = qs .. ' dhms.menu \'{"menu":"root"}\''
local powerMenu = qs .. ' dhms.menu \'{"menu":"system"}\''
local emoji = qs .. " dhms.emojis"
local keybinds = "dhms-menu-keybinds"
local restartQuickshell = "restart-quickshell"
local backgroundPicker = qs .. " dhms.image-picker"
local themePicker = 'theme=$(dhms-theme-switcher); [ -n "$theme" ] && theme-set "$theme"'
local screenrecord = "screenrecord --stop-recording || "
	.. qs
	.. ' dhms.menu \'{"menu":"trigger.capture.screenrecord"}\''
local whatsapp = 'uwsm-app -- "/opt/WhatsApp Desktop/whatsapp-linux-desktop"'
local muteOutput = "dhms-audio-output-volume mute-toggle"
local muteInput = "dhms-audio-input-mute"
local volumeDown = "dhms-audio-output-volume lower"
local volumeUp = "dhms-audio-output-volume raise"
local brightUp = "dhms-brightness-display +5%"
local brightDown = "dhms-brightness-display 5%-"

-- terminal
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal), { description = "terminal" })
-- hl.bind(
-- 	"SUPER + SHIFT + RETURN",
-- 	hl.dsp.exec_cmd(terminal .. " -e tmux attach || tmux new -s dhms"),
-- 	{ description = "tmux" }
-- )
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd(subTerminal), { description = "sub-terminal" })

-- menus
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(apps), { description = "apps" })
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd(menu), { description = "menu" })
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd(powerMenu), { description = "power menu" })
hl.bind("SUPER + E", hl.dsp.exec_cmd(emoji), { description = "emoji" })
hl.bind("SHIFT + ALT + DELETE", hl.dsp.exec_cmd(restartQuickshell), { description = "restart quickshell" })
hl.bind("SUPER + SHIFT + SLASH", hl.dsp.exec_cmd(keybinds), { description = "keybindings" })
hl.bind("SUPER + CTRL + SPACE", hl.dsp.exec_cmd(backgroundPicker), { description = "background" })
hl.bind("SUPER + CTRL + SHIFT + SPACE", hl.dsp.exec_cmd(themePicker), { description = "themes" })

-- base apps
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(browser), { description = "browser" })
hl.bind("SUPER + SHIFT + ALT + B", hl.dsp.exec_cmd(subBrowser), { description = "sub-browser" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("discord"), { description = "discord" })
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("Telegram"), { description = "telegram" })
hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd(whatsapp), { description = "whatsapp" })
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(fileManager), { description = "file manager" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(editor), { description = "editor" })
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd(qs .. " dhms.audio"), { description = "audio" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd(qs .. " dhms.bluetooth"), { description = "bluetooth" })
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd(qs .. " dhms.network"), { description = "network" })

-- window's management
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER+ T", hl.dsp.layout("togglesplit"), { description = "Toggle window split" })
hl.bind("SUPER+ P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind(
	"SUPER+ SHIFT + P",
	hl.dsp.window.float({ action = "toggle" }),
	{ description = "Toggle window floating/tiling" }
)
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Toggle full width" })
hl.bind("SUPER + CTRL + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Toggle full screen" })
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("dhms-lock"), { description = "lock screen" })
hl.bind("SUPER + TAB", hl.dsp.window.cycle_next(), { description = "Focus on next window" })
hl.bind("SUPER + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }), { description = "Focus on previous window" })
-- move focus with SUPER + VIM motion
hl.bind("SUPER + H", hl.dsp.focus({ direction = "l" }), { description = "move focus left" })
hl.bind("SUPER + L", hl.dsp.focus({ direction = "r" }), { description = "move focus right" })
hl.bind("SUPER + K", hl.dsp.focus({ direction = "u" }), { description = "move focus up" })
hl.bind("SUPER + J", hl.dsp.focus({ direction = "d" }), { description = "move focus down" })
-- swap focused window with SUPER + VIM motion
hl.bind("SUPER + SHIFT + H", hl.dsp.window.swap({ direction = "l" }), { description = "swap window left" })
hl.bind("SUPER + SHIFT + L", hl.dsp.window.swap({ direction = "r" }), { description = "swap window right" })
hl.bind("SUPER + SHIFT + K", hl.dsp.window.swap({ direction = "u" }), { description = "swap window up" })
hl.bind("SUPER + SHIFT + J", hl.dsp.window.swap({ direction = "d" }), { description = "swap window down" })
-- move focused window with SUPER + VIM motion
hl.bind("SUPER + CTRL + SHIFT + H", hl.dsp.window.move({ direction = "l" }), { description = "move window left" })
hl.bind("SUPER + CTRL + SHIFT + L", hl.dsp.window.move({ direction = "r" }), { description = "move window right" })
hl.bind("SUPER + CTRL + SHIFT + K", hl.dsp.window.move({ direction = "u" }), { description = "move window up" })
hl.bind("SUPER + CTRL + SHIFT + J", hl.dsp.window.move({ direction = "d" }), { description = "move window down" })
-- move/resize window with SUPER + LMB/RMN and dragging
hl.bind("SUPER + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })
-- resize window
hl.bind(
	"SUPER + code:20",
	hl.dsp.window.resize({ x = -100, y = 0, relative = true }),
	{ description = "Shrink window left" }
)
hl.bind(
	"SUPER + code:21",
	hl.dsp.window.resize({ x = 100, y = 0, relative = true }),
	{ description = "Expand window left" }
)
hl.bind(
	"SUPER + SHIFT + code:20",
	hl.dsp.window.resize({ x = 0, y = -100, relative = true }),
	{ description = "Expand window up" }
)
hl.bind(
	"SUPER + SHIFT + code:21",
	hl.dsp.window.resize({ x = 0, y = 100, relative = true }),
	{ description = "Shrink window down" }
)

-- toggle system
hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("toggle-idle"), { description = "toggle idle" })
hl.bind("SUPER + CTRL + ALT + L", hl.dsp.exec_cmd("toggle-layout"), { description = "toggle layout" })

-- universal clipboard
-- Send with explicit mods to the focused surface by omitting the window target,
-- so the shortcuts reach both normal windows and focused layer-shell surfaces
-- such as dhms panels. A virtual keyboard (wtype) won't do: the physically held
-- SUPER merges into the injected chord at the seat. The down/up split works
-- around Hyprland send_shortcut sometimes leaving synthetic key state
-- stuck/repeating.
-- https://github.com/hyprwm/Hyprland/discussions/14099
local function send_shortcut_once(mods, key)
	return function()
		hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))

		hl.timer(function()
			hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
		end, { timeout = 50, type = "oneshot" })
	end
end

-- Lean on the terminal tag from windows.lua so there's one definition of what
-- counts as a terminal. Dynamic tags carry a trailing "*".
local function active_window_is_terminal()
	local window = hl.get_active_window()
	if not window then
		return false
	end

	local tags = window.tags
	if type(tags) == "table" then
		for _, tag in ipairs(tags) do
			if tag:gsub("%*$", "") == "terminal" then
				return true
			end
		end
	end

	return false
end

local function universal_clipboard_shortcut(default_mods, default_key, terminal_mods, terminal_key)
	return function()
		if active_window_is_terminal() then
			send_shortcut_once(terminal_mods, terminal_key)()
		else
			send_shortcut_once(default_mods, default_key)()
		end
	end
end

-- utilities
hl.bind("SUPER + X", send_shortcut_once("CTRL", "X"), { description = "Universal cut" })
hl.bind("SUPER + C", universal_clipboard_shortcut("CTRL", "C", "CTRL", "Insert"), { description = "Universal copy" })
hl.bind("SUPER + V", universal_clipboard_shortcut("CTRL", "V", "SHIFT", "Insert"), { description = "Universal paste" })
hl.bind("SUPER + ALT + V", hl.dsp.exec_cmd(qs .. " dhms.clipboard"), { description = "Clipboard manager" })
-- hl.bind("XF86PowerOff", hl.dsp.exec_cmd("dhms-lock"), { description = "lock screen" })

-- notification controls
hl.bind(
	"SUPER + comma",
	hl.dsp.exec_cmd("dhms-shell notifications dismissAll"),
	{ description = "Dismiss all notifications" }
)
hl.bind(
	"SUPER + SHIFT + ALT + comma",
	hl.dsp.exec_cmd("dhms-shell notifications toggleDnd"),
	{ description = "Toggle silencing notifications" }
)
hl.bind(
	"SUPER + SHIFT + comma",
	hl.dsp.exec_cmd("dhms-shell notifications showHistory"),
	{ description = "Open notification history" }
)

-- screen capture
hl.bind("PRINT", hl.dsp.exec_cmd("screenshot"), { description = "screenshot" })
hl.bind("SHIFT + PRINT", hl.dsp.exec_cmd("screenshot smart clipboard"), { description = "screenshot (clipboard)" })
hl.bind("CTRL + PRINT", hl.dsp.exec_cmd("screenshot fullscreen"), { description = "screenshot (fullscreen)" })
hl.bind("ALT + PRINT", hl.dsp.exec_cmd(screenrecord), { description = "screenrecord" })

-- workspaces
for workspace = 1, 10 do
	local key = "code:" .. tostring(workspace + 9)
	hl.bind(
		"SUPER + " .. key,
		hl.dsp.focus({ workspace = tostring(workspace) }),
		{ description = "Switch to workspace " .. workspace }
	)
	hl.bind(
		"SUPER + SHIFT + " .. key,
		hl.dsp.window.move({ workspace = tostring(workspace) }),
		{ description = "Move window to workspace " .. workspace }
	)
	hl.bind(
		"SUPER + SHIFT + ALT + " .. key,
		hl.dsp.window.move({ workspace = tostring(workspace), follow = false }),
		{ description = "Move window silently to workspace " .. workspace }
	)
end

-- audio controls
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(muteOutput), { locked = true, repeating = true, description = "Mute" })
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(volumeDown),
	{ locked = true, repeating = true, description = "Volume down" }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(volumeUp),
	{ locked = true, repeating = true, description = "Volume up" }
)
hl.bind(
	"XF86AudioMicMute",
	hl.dsp.exec_cmd(muteInput),
	{ locked = true, repeating = true, description = "Mute microphone" }
)
-- brightness controls
hl.bind(
	"XF86MonBrightnessDown",
	hl.dsp.exec_cmd(brightDown),
	{ locked = true, repeating = true, description = "Brightness down" }
)
hl.bind(
	"XF86MonBrightnessUp",
	hl.dsp.exec_cmd(brightUp),
	{ locked = true, repeating = true, description = "Brightness up" }
)

-- audio controls (F1-F4)
hl.bind("SUPER + F1", hl.dsp.exec_cmd(muteOutput), { locked = true, repeating = true, description = "Mute" })
hl.bind("SUPER + F2", hl.dsp.exec_cmd(volumeDown), { locked = true, repeating = true, description = "Volume down" })
hl.bind("SUPER + F3", hl.dsp.exec_cmd(volumeUp), { locked = true, repeating = true, description = "Volume up" })
hl.bind("SUPER + F4", hl.dsp.exec_cmd(muteInput), { locked = true, repeating = true, description = "Mute microphone" })

-- brightness controls (F5-F6)
hl.bind("SUPER + F5", hl.dsp.exec_cmd(brightDown), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("SUPER + F6", hl.dsp.exec_cmd(brightUp), { locked = true, repeating = true, description = "Brightness up" })

---
