local menu = {
	label = "Main Menu", -- Optional root label
	submenus = { -- Top-level items
		{
			label = "Apps",
			icon = "󰀻",
			action = "walker -p 'Launch…'", -- Runs the apps launcher
		},
		{
			label = "Setup",
			icon = "",
			submenus = {
				{
					label = "Background",
					icon = "",
					action = "waypaper",
				},
				{
					label = "DNS",
					icon = "󰱔",
					action = "floating-terminal setup-dns",
				},
				{
					label = "Install",
					icon = "󰉉",
					submenus = {
						{
							label = "Package",
							icon = "󰣇",
							action = "xdg-terminal-exec --app-id=dhms.terminal pkg-install",
						},
						{
							label = "AUR",
							icon = "󰣇",
							action = "xdg-terminal-exec --app-id=dhms.terminal pkg-aur-install",
						},
					},
				},
				{
					label = "Power Profile",
					icon = "󱐋",
					submenus = function() -- Dynamic submenus via function
						local profiles = {}
						local current = io.popen("powerprofilesctl get"):read("*a"):gsub("\n", "")
						local list = io.popen("powerprofiles-list"):read("*a")
						for profile in list:gmatch("[^\n]+") do
							local item = {
								label = profile,
								icon = "󱐋",
								action = "powerprofilesctl set '" .. profile .. "'",
							}
							if profile == current then
								item.label = profile .. " (current)"
							end
							table.insert(profiles, item)
						end
						return profiles
					end,
				},
				{
					label = "Remove",
					icon = "󰭌",
					action = "xdg-terminal-exec --app-id=dhms.terminal pkg-remove",
				},
				{
					label = "Themes",
					icon = "󰸌",
					action = "walker -m menus:themesMenu --width 800 --minheight 400",
				},
				{
					label = "Security",
					icon = "",
					submenus = {
						{
							label = "Fingerprint",
							icon = "󰈷",
							action = "floating-terminal setup-fingerprint",
						},
						{
							label = "Fido2",
							icon = "",
							action = "floating-terminal setup-fido2",
						},
					},
				},
				{
					label = "Update",
					icon = "",
					action = "floating-terminal pkg-update",
				},
			},
		},
		{
			label = "System",
			icon = "",
			submenus = {
				{
					label = "Suspend",
					icon = "󰒲",
					action = "systemctl suspend",
				},
				{
					label = "Lock",
					icon = "",
					action = "hyprlock",
				},
				{
					label = "Reboot",
					icon = "󰜉",
					action = "systemctl reboot",
				},
				{
					label = "Shutdown",
					icon = "󰐥",
					action = "systemctl poweroff",
				},
			},
		},
	},
}

return menu
