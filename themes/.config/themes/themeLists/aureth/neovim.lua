return {
    {
        "bjarneo/aether.nvim",
        branch = "v2",
        name = "aether",
        priority = 1000,
        opts = {
            transparent = false,
            colors = {
                -- Background colors
                bg = "#2B2A27",
                bg_dark = "#2B2A27",
                bg_highlight = "#3A3833",

                -- Foreground colors
                fg = "#E6DCC6",
                fg_dark = "#6B675E",
                comment = "#4A463F",

                -- Accent colors
                red = "#C65A3A",
                orange = "#E37B52",
                yellow = "#D9A441",
                green = "#7C9A4D",
                cyan = "#5E8C83",
                blue = "#4A5D6B",
                purple = "#B07A8C",
                magenta = "#C996A7",
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