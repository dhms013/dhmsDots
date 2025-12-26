return {
  "NvChad/nvim-colorizer.lua",
  event = "VeryLazy",
  opts = {
    user_default_options = {
      css = true,
      scss = true,
      html = true,
      lua = true,
      mode = "virtualtext", -- or "background", "foreground"
    },
    -- Available modes: "virtualtext", "background", "foreground"
    -- virtualtext displays the color as a small square before the code.
  },
  config = function(_, opts)
    require("colorizer").setup(opts)
  end,
}
