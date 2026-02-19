Name = "backgroundSelector"
NamePretty = "Background Selector"
Cache = false
HideFromProviderlist = true
SearchName = true

function FormatName(filename)
	-- Remove leading number and dash
	-- local name = filename:gsub("^%d+", ""):gsub("^%-", "")
	-- Remove extension
	local name = filename:gsub("%.[^%.]+$", "")
	-- Replace dashes with spaces
	name = name:gsub("-", " ")
	-- Capitalize each word
	name = name:gsub("%S+", function(word)
		return word:sub(1, 1):upper() .. word:sub(2):lower()
	end)
	return name
end

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
					Text = FormatName(filename),
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
