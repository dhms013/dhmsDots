---------------------
---- KEYBINDINGS ----
---------------------

local terminal = "ghostty"
local fileManager = terminal .. " -e yazi"
local editor = terminal .. " --title=nvim -e nvim"
local browser = "zen-browser"
local qs = "quickshell ipc call"
local apps = qs .. " openApps handle"
local keybinds = qs .. " openKeybindings handle"
local menu = qs .. " openMenu handle"
local emoji = qs .. " openEmojiPicker handle"
local notification = qs .. " openNotificationPanel handle"
local notificationClear = qs .. " clearNotifications handle"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more

-- terminal
hl.bind("SUPER + RETURN", hl.dsp.exec_cmd(terminal), { description = "terminal" })
hl.bind("SUPER + SHIFT + RETURN", hl.dsp.exec_cmd("dhms-terminal tmux"), { description = "alt terminal" })

-- menus
hl.bind("SUPER + SPACE", hl.dsp.exec_cmd(apps), { description = "apps" })
hl.bind("SUPER + ALT + SPACE", hl.dsp.exec_cmd(menu), { description = "menu" })
hl.bind("SUPER + ESCAPE", hl.dsp.exec_cmd(qs .. "openSystem handle"), { description = "power menu" })
hl.bind("SUPER + E", hl.dsp.exec_cmd(emoji), { description = "emoji" })
hl.bind("SUPER + N", hl.dsp.exec_cmd(notification), { description = "notification" })
hl.bind("SHIFT + DELETE", hl.dsp.exec_cmd(notificationClear), { description = "clear notification" })
hl.bind("SUPER + SHIFT + SLASH", hl.dsp.exec_cmd(keybinds), { description = "keybindings" })

-- base apps
hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd(browser), { description = "browser" })
hl.bind("SUPER + SHIFT + D", hl.dsp.exec_cmd("discord"), { description = "discord" })
hl.bind("SUPER + SHIFT + T", hl.dsp.exec_cmd("Telegram"), { description = "telegram" })
hl.bind(
	"SUPER + SHIFT + W",
	hl.dsp.exec_cmd("uwsm-app -- /opt/WhatsApp Desktop/whatsapp-linux-desktop"),
	{ description = "whatsapp" }
)
hl.bind("SUPER + SHIFT + F", hl.dsp.exec_cmd(fileManager), { description = "file manager" })
hl.bind("SUPER + SHIFT + N", hl.dsp.exec_cmd(editor), { description = "editor" })
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd("dhms-terminal wiremix"), { description = "audio" })
hl.bind("SUPER + CTRL + B", hl.dsp.exec_cmd("dhms-terminal blutui"), { description = "bluetooth" })
hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("dhms-terminal impala"), { description = "wifi" })

-- window's management
hl.bind("SUPER + Q", hl.dsp.window.close(), { description = "Close window" })
hl.bind("SUPER+ T", hl.dsp.layout("togglesplit"), { description = "Toggle window split" })
hl.bind("SUPER+ P", hl.dsp.window.pseudo(), { description = "Pseudo window" })
hl.bind(
	"SUPER+ SHIFT + P",
	hl.dsp.window.float({ action = "toggle" }),
	{ description = "Toggle window floating/tiling" }
)
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }), { description = "Full screen" })
hl.bind(
	"SUPER + CTRL + F",
	hl.dsp.window.fullscreen_state({ internal = 0, client = 2 }),
	{ description = "Tiled full screen" }
)
hl.bind("SUPER + ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }), { description = "Full width" })
hl.bind("SUPER + CTRL + L", hl.dsp.exec_cmd("dhms-lock"), { description = "lock screen" })
hl.bind("ALT + TAB", hl.dsp.window.cycle_next(), { description = "Focus on next window" })
hl.bind("ALT + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }), { description = "Focus on previous window" })

-- toggle system
hl.bind("SUPER + CTRL + I", hl.dsp.exec_cmd("toggle-idle"), { description = "toggle idle" })
hl.bind("SUPER + CTRL + ALT + L", hl.dsp.exec_cmd("toggle-layout"), { description = "toggle layout" })

-- utilities
hl.bind("SUPER + X", hl.dsp.send_shortcut({ mods = "CTRL", key = "X" }), { description = "cut" })
hl.bind("SUPER + C", hl.dsp.send_shortcut({ mods = "CTRL", key = "Insert" }), { description = "copy" })
hl.bind("SUPER + V", hl.dsp.send_shortcut({ mods = "SHIFT", key = "Insert" }), { description = "paste" })

----
