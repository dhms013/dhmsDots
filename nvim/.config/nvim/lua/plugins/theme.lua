-- return {
--   "ribru17/bamboo.nvim",
--   lazy = false,
--   priority = 1000,
--   config = function()
--     require("bamboo").setup({
--       transparent = true,
--       styles = {
--         sidebars = "transparent",
--         floats = "transparent",
--       },
--     })
--     require("bamboo").load()
--   end,
-- }

-- return {
--   "LazyVim/LazyVim",
--   opts = {
--     colorscheme = function()
--       vim.cmd("set termguicolors")
--
--       local colors = {
--         bg = "#1e2a24",
--         fg = "#a8e6a1",
--         purple = "#9d7cd8",
--         primary = "#89f6c4",
--         secondary = "#6bbf7a",
--         success = "#B9E8B5",
--         danger = "#e06c75",
--         warning = "#e5c07b",
--         info = "#4DD0E1",
--         muted = "#5f876f",
--         dark = "#0f1a14",
--         accent = "#cddc39",
--         subtle = "#2a3f2d",
--         border = "#4a5f4d",
--         selection = "#2E4D3D",
--       }
--
--       vim.cmd("highlight clear")
--
--       local function set_hl(group, opts)
--         vim.api.nvim_set_hl(0, group, opts)
--       end
--
--       set_hl("Normal", { fg = colors.fg, bg = colors.bg })
--       set_hl("Comment", { fg = colors.muted, italic = true })
--       set_hl("Constant", { fg = colors.secondary })
--       set_hl("String", { fg = colors.success })
--       set_hl("Character", { fg = colors.success })
--       set_hl("Number", { fg = colors.accent })
--       set_hl("Boolean", { fg = colors.primary, bold = true })
--       set_hl("Float", { fg = colors.accent })
--       set_hl("Identifier", { fg = colors.info })
--       set_hl("Function", { fg = colors.primary, bold = true })
--       set_hl("Statement", { fg = colors.purple, bold = true })
--       set_hl("Conditional", { fg = colors.purple })
--       set_hl("Repeat", { fg = colors.purple })
--       set_hl("Label", { fg = colors.secondary })
--       set_hl("Operator", { fg = colors.fg })
--       set_hl("Keyword", { fg = colors.purple, bold = true })
--       set_hl("Exception", { fg = colors.danger })
--       set_hl("PreProc", { fg = colors.secondary })
--       set_hl("Include", { fg = colors.primary })
--       set_hl("Define", { fg = colors.primary })
--       set_hl("Macro", { fg = colors.warning })
--       set_hl("PreCondit", { fg = colors.secondary })
--       set_hl("Type", { fg = colors.warning, italic = true })
--       set_hl("StorageClass", { fg = colors.danger })
--       set_hl("Structure", { fg = colors.secondary })
--       set_hl("Typedef", { fg = colors.secondary })
--       set_hl("Special", { fg = colors.accent })
--       set_hl("SpecialChar", { fg = colors.accent })
--       set_hl("Tag", { fg = colors.info })
--       set_hl("Delimiter", { fg = colors.fg })
--       set_hl("SpecialComment", { fg = colors.muted })
--       set_hl("Debug", { fg = colors.danger })
--       set_hl("Title", { fg = colors.primary, bold = true })
--       set_hl("Directory", { fg = colors.info })
--       set_hl("MatchParen", { fg = colors.accent, bg = colors.subtle, bold = true })
--       set_hl("Conceal", { fg = colors.muted })
--       set_hl("NonText", { fg = colors.muted })
--       set_hl("SpecialKey", { fg = colors.muted })
--       set_hl("Whitespace", { fg = colors.muted })
--
--       set_hl("CursorLine", { bg = colors.dark })
--       set_hl("CursorColumn", { bg = colors.dark })
--       set_hl("CursorLineNr", { fg = colors.primary, bold = true })
--       set_hl("LineNr", { fg = colors.muted })
--       set_hl("SignColumn", { fg = colors.muted, bg = colors.bg })
--       set_hl("Visual", { bg = colors.selection })
--       set_hl("VisualNOS", { bg = colors.subtle })
--       set_hl("Search", { fg = colors.bg, bg = colors.primary })
--       set_hl("IncSearch", { fg = colors.bg, bg = colors.accent })
--       set_hl("Substitute", { fg = colors.bg, bg = colors.warning })
--       set_hl("Pmenu", { fg = colors.fg, bg = colors.dark })
--       set_hl("PmenuSel", { fg = colors.dark, bg = colors.primary })
--       set_hl("PmenuSbar", { bg = colors.subtle })
--       set_hl("PmenuThumb", { bg = colors.secondary })
--       set_hl("StatusLine", { fg = colors.fg, bg = colors.dark })
--       set_hl("StatusLineNC", { fg = colors.muted, bg = colors.dark })
--       set_hl("WinSeparator", { fg = colors.border })
--       set_hl("VertSplit", { fg = colors.border })
--       set_hl("Folded", { fg = colors.muted, bg = colors.subtle, italic = true })
--       set_hl("FoldColumn", { fg = colors.muted, bg = colors.bg })
--       set_hl("TabLine", { fg = colors.muted, bg = colors.dark })
--       set_hl("TabLineFill", { bg = colors.dark })
--       set_hl("TabLineSel", { fg = colors.primary, bg = colors.bg, bold = true })
--
--       set_hl("ErrorMsg", { fg = colors.bg, bg = colors.danger, bold = true })
--       set_hl("WarningMsg", { fg = colors.bg, bg = colors.warning })
--       set_hl("MoreMsg", { fg = colors.success })
--       set_hl("ModeMsg", { fg = colors.primary, bold = true })
--       set_hl("Question", { fg = colors.info })
--       set_hl("DiffAdd", { bg = "#2D4A3D" })
--       set_hl("DiffChange", { bg = "#3D3A2D" })
--       set_hl("DiffDelete", { bg = "#4A2D2D" })
--       set_hl("DiffText", { bg = "#4A4A2D", bold = true })
--
--       set_hl("SpellBad", { undercurl = true, sp = colors.danger })
--       set_hl("SpellCap", { undercurl = true, sp = colors.warning })
--       set_hl("SpellLocal", { undercurl = true, sp = colors.info })
--       set_hl("SpellRare", { undercurl = true, sp = colors.accent })
--
--       set_hl("DiagnosticError", { fg = colors.danger })
--       set_hl("DiagnosticWarn", { fg = colors.warning })
--       set_hl("DiagnosticInfo", { fg = colors.info })
--       set_hl("DiagnosticHint", { fg = colors.muted })
--       set_hl("DiagnosticUnderlineError", { undercurl = true, sp = colors.danger })
--       set_hl("DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warning })
--       set_hl("DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info })
--       set_hl("DiagnosticUnderlineHint", { undercurl = true, sp = colors.muted })
--
--       set_hl("@text", { link = "Normal" })
--       set_hl("@comment", { link = "Comment" })
--       set_hl("@constant", { link = "Constant" })
--       set_hl("@constant.builtin", { fg = colors.danger, bold = true })
--       set_hl("@string", { link = "String" })
--       set_hl("@character", { link = "Character" })
--       set_hl("@number", { link = "Number" })
--       set_hl("@boolean", { link = "Boolean" })
--       set_hl("@float", { link = "Float" })
--       set_hl("@function", { link = "Function" })
--       set_hl("@function.builtin", { fg = colors.accent, bold = true })
--       set_hl("@method", { link = "Function" })
--       set_hl("@keyword", { link = "Keyword" })
--       set_hl("@keyword.function", { link = "Keyword" })
--       set_hl("@keyword.operator", { link = "Keyword" })
--       set_hl("@operator", { link = "Operator" })
--       set_hl("@preproc", { link = "PreProc" })
--       set_hl("@type", { link = "Type" })
--       set_hl("@type.builtin", { fg = colors.warning, bold = true })
--       set_hl("@storageclass", { link = "StorageClass" })
--       set_hl("@variable", { link = "Identifier" })
--       set_hl("@variable.builtin", { fg = colors.danger, bold = true, italic = true })
--       set_hl("@property", { fg = colors.info })
--       set_hl("@field", { fg = colors.info })
--       set_hl("@parameter", { fg = colors.warning, italic = true })
--       set_hl("@punctuation.bracket", { link = "Delimiter" })
--       set_hl("@punctuation.delimiter", { link = "Delimiter" })
--       set_hl("@tag", { link = "Tag" })
--       set_hl("@tag.attribute", { fg = colors.secondary })
--       set_hl("@tag.delimiter", { fg = colors.muted })
--       set_hl("@constructor", { fg = colors.purple })
--       set_hl("@namespace", { fg = colors.info })
--       set_hl("@include", { link = "Include" })
--       set_hl("@conditional", { link = "Conditional" })
--       set_hl("@repeat", { link = "Repeat" })
--       set_hl("@label", { link = "Label" })
--       set_hl("@exception", { link = "Exception" })
--       set_hl("@text.title", { link = "Title" })
--       set_hl("@text.literal", { link = "String" })
--       set_hl("@text.uri", { fg = colors.success, underline = true })
--       set_hl("@text.emphasis", { italic = true })
--       set_hl("@text.strong", { bold = true })
--       set_hl("@text.todo", { fg = colors.bg, bg = colors.warning, bold = true })
--
--       set_hl("@lsp.type.variable", {})
--       set_hl("@lsp.type.property", { link = "@property" })
--       set_hl("@lsp.type.function", { link = "@function" })
--       set_hl("@lsp.type.method", { link = "@method" })
--       set_hl("@lsp.type.keyword", { link = "@keyword" })
--       set_hl("@lsp.type.namespace", { link = "@namespace" })
--       set_hl("@lsp.type.parameter", { link = "@parameter" })
--       set_hl("@lsp.type.type", { link = "Type" })
--       set_hl("@lsp.type.class", { link = "Type" })
--       set_hl("@lsp.type.struct", { link = "Type" })
--       set_hl("@lsp.type.enum", { link = "Type" })
--       set_hl("@lsp.type.interface", { link = "Type" })
--
--       vim.g.colors_name = "abhijeet_custom"
--     end,
--   },
-- }
--
return {
  "EdenEast/nightfox.nvim",
  lazy = false,
  priority = 1000,
  dependencies = {
    "folke/snacks.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-lualine/lualine.nvim",
  },

  config = function()
    local nightfox = require("nightfox")
    local Shade = require("nightfox.lib.shade")
    local c = require("nightfox.lib.color")

    local retropc_palette = {
      -- Base "RetroPC" Palette Overrides
      bg0 = "#090A08",
      bg1 = "#090A08",
      bg2 = "#121a12",
      bg3 = "#02160C",
      bg4 = "#02160C",
      fg0 = "#59CF77",
      fg1 = "#59CF77",
      fg2 = "#2E7D4A",
      fg3 = "#669900",
      sel0 = "#02160C",
      sel1 = c.from_hex("#02160C"):blend(c.from_hex("#2E7D4A"), 0.2):to_css(),
      comment = "#008000",
      red = Shade.new("#59CF77", c.from_hex("#59CF77"):lighten(8):to_css(), "#59CF77"),
      orange = Shade.new("#59CF77", "#2E7D4A", c.from_hex("#59CF77"):lighten(-8):to_css()),
      yellow = Shade.new("#59CF77", c.from_hex("#2E7D4A"):lighten(10):to_css(), "#59CF77"),
      white = Shade.new("#59CF77", "#2E7D4A", "#2E7D4A"),
      black = Shade.new("#2A1F00", "#805500", "#1A1612"),
      green = Shade.new("#2E7D4A", "#D4AA00", "#669900"),
      cyan = Shade.new("#52D374", "#59CF77", "#2E7D4A"),
      blue = Shade.new("#2E7D4A", "#D4AA00", "#669900"),
      magenta = Shade.new("#4DB866", "#52D374", "#22CC00"),
      pink = Shade.new("#52D374", "#59CF77", "#22CC00"),

      -- Lualine Palette Extensions
      lualine_normal_bg = "#FFBB00",
      lualine_insert_bg = "#FF8800",
      lualine_visual_bg = "#FF9900",
      lualine_command_bg = "#FFBB00",
      lualine_inactive_bg = c.from_hex("#0A0A08"):lighten(5):to_css(),

      -- Treesitter Palette Extensions
      ts_parameter = "#FFAA00",
      ts_property = "#FFB000",
    }

    local final_palettes = {
      carbonfox = require("nightfox.lib.collect").deep_extend(
        require("nightfox.palette").load("carbonfox"),
        retropc_palette
      ),
    }

    local specs = {
      carbonfox = {
        syntax = {
          keyword = "red", -- "local", "function", "if"
          conditional = "red",
          statement = "red",
          func = "orange",
          string = "orange.dim",
          number = "orange",
          operator = "yellow",
          variable = "white",
          ident = "white.dim",
          const = "white",
          type = "white",
          field = "white.dim",
          comment = "comment",
        },
        diag = {
          error = "red",
          warn = "red",
          info = "cyan",
          hint = "magenta",
        },
      },
    }

    local groups = {
      all = {
        -- Base Groups
        Whitespace = { fg = "palette.black.bright" },
        NonText = { fg = "palette.black.bright" },
        IncSearch = { bg = "palette.sel1" },
        CursorLine = { bg = "palette.bg2" },
        Normal = { fg = "palette.fg1" },

        -- Noice Cmdline Overrides
        NoiceCmdlinePopupBorder = { fg = "palette.fg3" },
        NoiceCmdlinePopupTitle = { fg = "palette.fg3", style = "bold" },
        NoiceCmdlinePopupBorderSearch = { fg = "palette.fg3" },
        NoiceCmdlinePopupTitleSearch = { fg = "palette.fg3", style = "bold" },
        NoiceCmdLineIcon = { fg = "palette.red" },

        -- Neo-tree overrides
        NeoTreeNormal = { bg = "palette.bg0" },
        NeoTreeNormalNC = { link = "NeoTreeNormal" },
        NeoTreeDirectoryName = { fg = "palette.fg3" },
        NeoTreeDirectoryIcon = { fg = "palette.fg3" },
        NeoTreeRootName = { fg = "palette.orange", style = "bold" },
        NeoTreeGitAdded = { fg = "palette.green" },
        NeoTreeGitModified = { fg = "palette.yellow" },
        NeoTreeGitDeleted = { fg = "palette.red" },
        NeoTreeGitIgnored = { fg = "palette.comment" },
        NeoTreeC = { fg = "palette.orange", bg = "palette.sel0" },

        -- Dashboard overrides
        SnacksDashboardHeader = { fg = "palette.fg3" },
        SnacksDashboardIcon = { fg = "palette.fg1" },
        SnacksDashboardDir = { fg = "palette.green" },
        SnacksDashboardFile = { fg = "palette.fg3" },
        SnacksDashboardFooter = { fg = "palette.fg3" },
        SnacksDashboardKey = { fg = "palette.green" },
        SnacksDashboardDesc = { fg = "palette.fg1" },
        SnacksDashboardSpecial = { fg = "palette.fg1" },

        -- Treesitter overrides
        ["@comment"] = { fg = "palette.comment", style = "italic" },
        ["@keyword"] = { fg = "palette.red", style = "bold" },
        ["@keyword.function"] = { fg = "palette.red", style = "bold" },
        ["@keyword.operator"] = { fg = "palette.red", style = "bold" },
        ["@function"] = { fg = "palette.orange", style = "bold" },
        ["@function.builtin"] = { fg = "palette.orange", style = "bold" },
        ["@function.call"] = { fg = "palette.orange" },
        ["@string"] = { fg = "palette.orange" },
        ["@number"] = { fg = "palette.orange" },
        ["@operator"] = { fg = "palette.yellow" },
        ["@variable"] = { fg = "palette.white" },
        ["@constant"] = { fg = "palette.white" },
        ["@type"] = { fg = "palette.white.dim" },
        ["@variable.parameter"] = { fg = "palette.ts_parameter", style = "italic" },
        ["@property"] = { fg = "palette.ts_property" },
        ["@field"] = { fg = "palette.ts_property" },
      },
    }

    nightfox.setup({
      options = {
        style = "carbonfox",
        terminal_colors = true,
        dim_inactive = true,
        styles = { comments = "italic", functions = "bold", keywords = "bold" },
        modules = {
          neotree = true,
          treesitter = true,
        },
      },
      palettes = final_palettes,
      specs = specs,
      groups = groups,
    })

    vim.cmd("colorscheme carbonfox")

    -- Lualine overrides
    local lualine_theme = {
      normal = {
        a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_normal_bg, gui = "bold" },
        b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
        c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
      },
      insert = {
        a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_insert_bg, gui = "bold" },
        b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
        c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
      },
      visual = {
        a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_visual_bg, gui = "bold" },
        b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
        c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
      },
      command = {
        a = { fg = retropc_palette.bg0, bg = retropc_palette.lualine_command_bg, gui = "bold" },
        b = { fg = retropc_palette.fg1, bg = retropc_palette.lualine_inactive_bg },
        c = { fg = retropc_palette.fg2, bg = retropc_palette.lualine_inactive_bg },
      },
      inactive = {
        a = { fg = retropc_palette.fg3, bg = retropc_palette.lualine_inactive_bg },
        b = { fg = retropc_palette.fg3, bg = retropc_palette.lualine_inactive_bg },
        c = { fg = retropc_palette.comment, bg = retropc_palette.lualine_inactive_bg },
      },
    }

    require("lualine").setup({
      options = {
        theme = lualine_theme,
      },
    })
  end,
}
