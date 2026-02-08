-- Neovim Theme - Ado Style
-- Editor theme based on Adobe colors

vim.cmd("hi clear")
vim.cmd("syntax reset")

vim.g.colors_name = "ado"
vim.g.background = "dark"

-- Enable true colors
vim.o.termguicolors = true
local colors = {
	bg = "#0D0D0F",
	fg = "#DFDEE6",
	bg_alt = "#333242",
	fg_alt = "#DAD8E3",

	black = "#333242",
	red = "#903034",
	green = "#014761",
	yellow = "#8BB0C6",
	blue = "#4545F5",
	magenta = "#25516A",
	cyan = "#45C1DD",
	white = "#DAD8E3",

	black_gray = "#908EAA",
	bright_red = "#D7878B",
	bright_green = "#33C6FC",
	bright_yellow = "#7DC0D3",
	bright_blue = "#A2A2FA",
	bright_magenta = "#76AFCF",
	bright_cyan = "#A2E0EE",
	bright_white = "#ECEBF1",
	blush = "#ECEBF1",
}

local function hi(group, opts)
	local cmd = "hi " .. group
	if opts.fg then
		cmd = cmd .. " guifg=" .. opts.fg
	end
	if opts.bg then
		cmd = cmd .. " guibg=" .. opts.bg
	end
	if opts.style then
		cmd = cmd .. " gui=" .. opts.style
	end
	if opts.sp then
		cmd = cmd .. " guisp=" .. opts.sp
	end
	vim.cmd(cmd)
end
-- === HIGHLIGHTS BASE ===

-- Editor
hi("Normal", { fg = colors.fg, bg = colors.bg })
hi("NormalFloat", { fg = colors.fg, bg = colors.bg_alt })
hi("NormalNC", { fg = colors.fg_alt, bg = colors.bg })

-- Cursor
hi("Cursor", { fg = colors.fg, bg = colors.bg })
hi("CursorLine", { bg = colors.black })
hi("CursorColumn", { bg = colors.black })
hi("Visual", { bg = colors.black_gray, fg = colors.white })
hi("VisualNOS", { bg = colors.bright_magenta })

--Linea
hi("LineNr", { fg = colors.bright_white })
hi("CursorLineNr", { fg = colors.bright_blue, style = "bold" })
hi("SignColumn", { fg = colors.bright_white, bg = colors.bg })
hi("FoldColumn", { fg = colors.bright_white, bg = colors.bg })

-- Search
hi("Search", { bg = colors.blue, fg = colors.white })
hi("IncSearch", { bg = colors.bright_blue, fg = colors.black })
hi("Substitute", { bg = colors.green, fg = colors.black })

-- Messaggi
hi("ErrorMsg", { fg = colors.blush, style = "bold" })
hi("WarningMsg", { fg = colors.bright_yellow, style = "bold" })
hi("ModeMsg", { fg = colors.bright_blue, style = "bold" })
hi("MoreMsg", { fg = colors.red })

-- === SYNTAX HIGHLIGHTING ===

-- Comentarios
hi("Comment", { fg = colors.bright_white, style = "italic" })
hi("SpecialComment", { fg = colors.red, style = "italic" })

-- Costantes
hi("Constant", { fg = colors.blue })
hi("String", { fg = colors.bright_white })
hi("Character", { fg = colors.bright_white })
hi("Number", { fg = colors.bright_cyan })
hi("Boolean", { fg = colors.bright_cyan })
hi("Float", { fg = colors.bright_cyan })

-- Identificadores
hi("Identifier", { fg = colors.fg })
hi("Function", { fg = colors.bright_red, style = "italic" })

-- Statements
hi("Statement", { fg = colors.red, style = "bold" })
hi("Conditional", { fg = colors.bright_red, style = "bold" })
hi("Repeat", { fg = colors.bright_red, style = "bold" })
hi("Label", { fg = colors.bright_red })
hi("Operator", { fg = colors.bright_red })
hi("Keyword", { fg = colors.red, style = "bold" })
hi("Exception", { fg = colors.red, style = "bold" })

-- Preprocessor
hi("PreProc", { fg = colors.bright_blue })
hi("Include", { fg = colors.blue })
hi("Define", { fg = colors.bright_blue })
hi("Macro", { fg = colors.bright_red })
hi("PreCondit", { fg = colors.bright_red })

-- Types
hi("Type", { fg = colors.bright_red, style = "bold" })
hi("StorageClass", { fg = colors.bright_red })
hi("Structure", { fg = colors.bright_red })
hi("Typedef", { fg = colors.bright_red })

-- Specials
hi("Special", { fg = colors.bright_blue })
hi("SpecialChar", { fg = colors.bright_blue })
hi("Tag", { fg = colors.red })
hi("Delimiter", { fg = colors.fg_alt })
hi("Debug", { fg = colors.blush })

-- Underlined e Errori
hi("Underlined", { fg = colors.red, style = "underline" })
hi("Ignore", { fg = colors.bright_white })
hi("Error", { fg = colors.blush, bg = colors.bg_alt, style = "bold" })
hi("Todo", { fg = colors.black, bg = colors.bright_blue, style = "bold" })

-- === DIFF ===
hi("DiffAdd", { fg = colors.green, bg = colors.black_gray })
hi("DiffChange", { fg = colors.red, bg = colors.black_gray })
hi("DiffDelete", { fg = colors.blush, bg = colors.black_gray })
hi("DiffText", { fg = colors.white, bg = colors.blue })

-- === POPUP MENU ===
hi("Pmenu", { fg = colors.fg, bg = colors.bg_alt })
hi("PmenuSel", { fg = colors.white, bg = colors.blue })
hi("PmenuSbar", { bg = colors.yellow })
hi("PmenuThumb", { bg = colors.bright_blue })

-- === STATUSLINE ===
hi("StatusLine", { fg = colors.white, bg = colors.blue })
hi("StatusLineNC", { fg = colors.bright_white, bg = colors.black_gray })

-- === TABLINE ===
hi("TabLine", { fg = colors.fg_alt, bg = colors.black_gray })
hi("TabLineFill", { bg = colors.bg_alt })
hi("TabLineSel", { fg = colors.white, bg = colors.blue, style = "bold" })

-- === SPLITS ===
hi("VertSplit", { fg = colors.yellow, bg = colors.bg })
hi("WinSeparator", { fg = colors.blue, bg = colors.bg })

-- === FOLDING ===
hi("Folded", { fg = colors.bright_white, bg = colors.black_gray })

-- === SPELL ===
hi("SpellBad", { sp = colors.blush, style = "undercurl" })
hi("SpellCap", { sp = colors.red, style = "undercurl" })
hi("SpellLocal", { sp = colors.bright_yellow, style = "undercurl" })
hi("SpellRare", { sp = colors.green, style = "undercurl" })

-- === PLUGINS SPECIFICI ===

-- LSP
hi("LspReferenceText", { bg = colors.black_gray })
hi("LspReferenceRead", { bg = colors.black_gray })
hi("LspReferenceWrite", { bg = colors.black_gray })

-- Diagnostics
hi("DiagnosticError", { fg = colors.blush })
hi("DiagnosticWarn", { fg = colors.bright_yellow })
hi("DiagnosticInfo", { fg = colors.red })
hi("DiagnosticHint", { fg = colors.green })

hi("DiagnosticSignError", { fg = colors.blush, bg = colors.bg })
hi("DiagnosticSignWarn", { fg = colors.bright_yellow, bg = colors.bg })
hi("DiagnosticSignInfo", { fg = colors.red, bg = colors.bg })
hi("DiagnosticSignHint", { fg = colors.green, bg = colors.bg })

-- GitSigns
hi("GitSignsAdd", { fg = colors.green, bg = colors.bg })
hi("GitSignsChange", { fg = colors.red, bg = colors.bg })
hi("GitSignsDelete", { fg = colors.blush, bg = colors.bg })

-- Telescope
hi("TelescopeNormal", { fg = colors.fg, bg = colors.bg_alt })
hi("TelescopeBorder", { fg = colors.blue, bg = colors.bg_alt })
hi("TelescopePromptBorder", { fg = colors.bright_blue, bg = colors.bg_alt })
hi("TelescopeResultsBorder", { fg = colors.blue, bg = colors.bg_alt })
hi("TelescopePreviewBorder", { fg = colors.red, bg = colors.bg_alt })

hi("TelescopeSelectionCaret", { fg = colors.bright_blue, bg = colors.black_gray })
hi("TelescopeSelection", { fg = colors.white, bg = colors.black_gray })
hi("TelescopeMatching", { fg = colors.bright_blue, style = "bold" })

-- NvimTree
hi("NvimTreeNormal", { fg = colors.fg, bg = colors.bg_alt })
hi("NvimTreeFolderIcon", { fg = colors.blue })
hi("NvimTreeFolderName", { fg = colors.red })
hi("NvimTreeOpenedFolderName", { fg = colors.bright_blue, style = "bold" })
hi("NvimTreeSpecialFile", { fg = colors.green, style = "bold" })
hi("NvimTreeExecutableFile", { fg = colors.bright_yellow, style = "bold" })

-- Indent Blankline
hi("IndentBlanklineChar", { fg = colors.black_gray })
hi("IndentBlanklineContextChar", { fg = colors.blue })

-- Which Key
hi("WhichKey", { fg = colors.bright_blue, style = "bold" })
hi("WhichKeyGroup", { fg = colors.red })
hi("WhichKeyDesc", { fg = colors.fg })
hi("WhichKeySeperator", { fg = colors.yellow })

-- Render Markdown
-- Fondos (Backgrounds)
hi("RenderMarkdownH1Bg", { bg = colors.blue })
hi("RenderMarkdownH2Bg", { bg = colors.red })
hi("RenderMarkdownH3Bg", { bg = colors.green })
hi("RenderMarkdownH4Bg", { bg = colors.magenta })
hi("RenderMarkdownH5Bg", { bg = colors.cyan })
hi("RenderMarkdownH6Bg", { bg = colors.black })

-- Textos (Foregrounds)
hi("RenderMarkdownH1", { fg = colors.white, style = "bold" })
hi("RenderMarkdownH2", { fg = colors.white, style = "bold" })
hi("RenderMarkdownH3", { fg = colors.white, style = "bold" })
hi("RenderMarkdownH4", { fg = colors.white, style = "bold" })
hi("RenderMarkdownH5", { fg = colors.white, style = "bold" })
hi("RenderMarkdownH6", { fg = colors.white, style = "bold" })

-- Terminal
vim.g.terminal_color_0 = colors.black
vim.g.terminal_color_1 = colors.blush
vim.g.terminal_color_2 = colors.green
vim.g.terminal_color_3 = colors.bright_yellow
vim.g.terminal_color_4 = colors.bright_magenta
vim.g.terminal_color_5 = colors.blue
vim.g.terminal_color_6 = colors.red
vim.g.terminal_color_7 = colors.fg
vim.g.terminal_color_8 = colors.yellow
vim.g.terminal_color_9 = colors.blue
vim.g.terminal_color_10 = colors.green
vim.g.terminal_color_11 = colors.bright_yellow
vim.g.terminal_color_12 = colors.red
vim.g.terminal_color_13 = colors.bright_blue
vim.g.terminal_color_14 = colors.fg_alt
vim.g.terminal_color_15 = colors.white
