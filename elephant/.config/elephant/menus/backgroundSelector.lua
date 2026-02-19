Name = "backgroundSelector"
NamePretty = "Background Selector"
Cache = false
HideFromProviderlist = true
SearchName = true

function GetEntries()
	local entries = {}
	local wallpaper_dir = os.getenv("HOME") .. "/.config/themes/current/theme/backgrounds"
	local handle = io.popen(
		"find '"
			.. wallpaper_dir
			.. "' -maxdepth 1 -type f \\( -name '*.jpg' -o -name '*.jpeg' -o -name '*.png' -o -name '*.gif' -o -name '*.bmp' -o -name '*.webp' \\) 2>/dev/null"
	)
	if handle then
		for background in handle:lines() do
			local filename = background:match("([^/]+)$")
			if filename then
				table.insert(entries, {
					Text = filename,
					Value = background,
					Actions = {
						activate = "background-set '" .. background .. "'",
					},
					Preview = background,
					PreviewType = "file",
				})
			end
		end
		handle:close()
	end
	return entries
end
