------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/

-- A built-in laptop panel (eDP-*) only exists on portable machines, so its
-- presence tells the office/laptop layout apart from the desktop PC:
--   * laptop at office -> external HDMI-A-1 sits ABOVE the laptop screen (0x-1080)
--   * desktop PC       -> HDMI-A-1 is the sole monitor, anchored at 0x0
-- A monitor MUST sit at 0x0 or Hyprland squishes Chromium's Wayland subsurface
-- bubbles (e.g. the profile menu) -> Hyprland #2003 / #10515.
local function output_connected(output)
	local handle = io.popen("cat /sys/class/drm/card*-" .. output .. "/status 2>/dev/null")
	if not handle then
		return false
	end
	for line in handle:lines() do
		if line:match("^connected") then
			handle:close()
			return true
		end
	end
	handle:close()
	return false
end

local has_laptop_panel = output_connected("eDP-1")

hl.monitor({
	output = "HDMI-A-1",
	mode = "highrr",
	position = has_laptop_panel and "0x-1080" or "0x0",
	scale = "1",
	-- mirror = "eDP-1",
})

hl.monitor({
	output = "DP-2",
	mode = "preferred",
	position = "-1920x-1080",
	transform = 2,
	scale = "1",
})

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = "1",
})
