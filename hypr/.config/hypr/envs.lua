-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

local paths = require("default.hypr.paths")

local function require_file_if_exists(path, module)
	local file = io.open(path, "r")
	if file then
		file:close()
		require(module)
	end
end

-- GUM environment variables for styling purposes.
require_file_if_exists(paths.confPath .. "themes.current.theme.gum_env")

hl.env("GDK_SCALE,1")
hl.env("XCURSOR_SIZE,24")
hl.env("HYPRCURSOR_SIZE,24")
hl.env("WLR_RENDER_WITHOUT_EXT_BUFFER,1")
hl.env("SDL_VIDEODRIVER,wayland")
hl.env("MOZ_ENABLE_WAYLAND,1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT,wayland")
hl.env("OZONE_PLATFORM,wayland")
hl.env("QT_QPA_PLATFORM,wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME,qt6ct")

-- NVIDIA
hl.env("LIBVA_DRIVER_NAME,nvidia")
hl.env("GBM_BACKEND,nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME,nvidia")
hl.env("NVD_BACKEND,direct")
hl.env("WLR_NO_HARDWARE_CURSORS,1")
