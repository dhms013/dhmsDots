return {
    {
        "bjarneo/aether.nvim",
        name = "aether",
        priority = 1000,
        opts = {
            disable_italics = false,
            colors = {
                -- Monotone shades (base00-base07)
                base00 = "#0e0e11", -- Default background
                base01 = "#9b9bb0", -- Lighter background (status bars)
                base02 = "#0e0e11", -- Selection background
                base03 = "#9b9bb0", -- Comments, invisibles
                base04 = "#faf9fa", -- Dark foreground
                base05 = "#faf9f9", -- Default foreground
                base06 = "#faf9f9", -- Light foreground
                base07 = "#faf9fa", -- Light background

                -- Accent colors (base08-base0F)
                base08 = "#c9aaee", -- Variables, errors, red
                base09 = "#caa8f0", -- Integers, constants, orange
                base0A = "#c5a8f0", -- Classes, types, yellow
                base0B = "#7e83ce", -- Strings, green
                base0C = "#827ece", -- Support, regex, cyan
                base0D = "#827ece", -- Functions, keywords, blue
                base0E = "#c8aeea", -- Keywords, storage, magenta
                base0F = "#e3b5b5", -- Deprecated, brown/yellow
            },
        },
        config = function(_, opts)
            require("aether").setup(opts)
            vim.cmd.colorscheme("aether")

            -- Enable hot reload
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
