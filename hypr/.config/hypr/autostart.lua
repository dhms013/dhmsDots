-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
	hl.exec_cmd("uwsm-app -- hypridle")
	hl.exec_cmd("wl-paste --type text --watch wl-copy --primary")
	hl.exec_cmd("uwsm-app -- awww-daemon")
	hl.exec_cmd("uwsm-app -- quickshell")
	hl.exec_cmd("dbus-update-activation-environment --systemd --all")
end)
