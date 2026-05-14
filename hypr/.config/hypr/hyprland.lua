local home = os.getenv("HOME") or ""

package.path = home .. "/.config/?.lua;" .. package.path

local paths = require("default.hypr.paths")

require("hypr.autostart.lua")
require("hypr.envs.lua")
require("hypr.input.lua")
require("hypr.keybindings.lua")
require("hypr.looknfeel.lua")
require("hypr.monitors.lua")
require("hypr.windows.lua")

do
	local theme = io.open(paths.config_home .. "/themes/current/theme/hyprland.lua", "r")
	if theme then
		theme:close()
		require("themes.current.theme.hyprland")
	end
end
