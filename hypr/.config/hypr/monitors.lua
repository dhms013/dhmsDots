------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@60",
	position = "0x0",
	scale = "1",
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "preferred",
	position = "0x-1080",
	scale = "1",
})

hl.monitor({
	output = "DP-2",
	mode = "preferred",
	position = "-1920x-1080",
	transform = 2,
	scale = "1",
})

hl.monitor({
	output = "HDMI-A-1",
	mode = "1920x1080@165.00",
	position = "auto",
	scale = "1",
})
