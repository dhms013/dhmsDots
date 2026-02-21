return {
    {
        "bjarneo/aether.nvim",
        branch = "v2",
        name = "aether",
        priority = 1000,
        opts = {
            transparent = false,
            colors = {
                -- Background colors - dark hacker/matrix
                bg = "#0a0a0a",
                bg_dark = "#0d1117",

                fg = "#00ff00",
                -- fg_dark: Inactive elements, statusline, secondary text
                fg_dark = "#003300",
                -- comment: Line highlight, gutter elements, disabled states
                comment = "#003300",

                -- Accent colors
                -- red: Errors, diagnostics, tags, deletions, breakpoints
                red = "#ff0000",
                -- orange: Constants, numbers, current line number, git modifications
                orange = "#ff6600",
                -- yellow: Types, classes, constructors, warnings, numbers, booleans
                yellow = "#ffff00",
                -- green: Comments, strings, success states, git additions
                green = "#00ff00",
                -- cyan: Parameters, regex, preprocessor, hints, properties
                cyan = "#00ffff",
                -- blue: Functions, keywords, directories, links, info diagnostics
                blue = "#00ffff",
                -- purple: Storage keywords, special keywords, identifiers, namespaces
                purple = "#ff6600",
                -- magenta: Function declarations, exception handling, tags
                magenta = "#ff9933",
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
