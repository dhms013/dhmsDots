return {
  {
    "bjarneo/aether.nvim",
    branch = "v2",
    name = "aether",
    priority = 1000,
    opts = {
      transparent = false,
      colors = {
        -- Backgrounds
        bg = "#0c0b0c",
        bg_dark = "#0c0b0c",
        bg_highlight = "#33241f",

        -- Foregrounds
        fg = "#eaeceb",       -- softened foreground for long sessions
        fg_dark = "#e2dddc",  -- secondary text / statusline
        comment = "#72747b",  -- readable but clearly secondary

        -- Accents / syntax
        red = "#934e39",      -- errors, diagnostics
        orange = "#704e44",   -- numbers, constants
        yellow = "#b59790",   -- types, booleans
        green = "#a2b7c1",    -- strings, success
        cyan = "#4b6566",     -- parameters, hints
        blue = "#a2b7c1",     -- functions, keywords
        purple = "#b59790",   -- special keywords
        magenta = "#a5a0b6",  -- function declarations
      },
    },
    config = function(_, opts)
      require("aether").setup(opts)
      vim.cmd.colorscheme("aether")
      require("aether.hotreload").setup()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
