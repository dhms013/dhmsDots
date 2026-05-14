local home = os.getenv("HOME") or ""

package.path = home .. "/.config/themes/current/theme/?.lua;" .. home .. "/.config/hypr/?.lua;" .. package.path

local paths = require("paths")

require("autostart")
require("envs")
require("input")
require("keybindings")
require("looknfeel")
require("monitors")
require("windows")

do
	local theme = io.open(paths.confPath .. "/themes/current/theme/hyprland.lua", "r")
	if theme then
		theme:close()
		require("hyprland")
	end
end
