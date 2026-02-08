return {
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = function()
                local colors = {
                    bg_dark = '#090300',
                    bg_medium = '#1a1412',
                    bg_light = '#2a2220',
                    bg_highlight = '#3a3432',

                    fg_main = '#ff3c3c',
                    fg_dim = '#a5a2a2',
                    fg_bright = '#f7f7f7',

                    red = '#ff1100',
                    green = '#01a252',
                    yellow = '#fded02',
                    blue = '#26bdfd',
                    purple = '#a16a94',
                    cyan = '#b5e4f4',

                    bright_black = '#5c5855',
                    bright_red = '#e8bbd0',
                    bright_green = '#3a3432',
                    bright_yellow = '#ff9494',
                    bright_blue = '#807d7c',
                    bright_purple = '#d6d5d4',
                    bright_cyan = '#cdab53',
                }
                ---@diagnostic disable: undefined-global
                vim.cmd('highlight clear')
                if vim.fn.exists('syntax_on') then
                    vim.cmd('syntax reset')
                end

                vim.o.termguicolors = true
                vim.o.background = 'dark'
                vim.g.colors_name = 'cyberpunk'

                local hl = vim.api.nvim_set_hl

                hl(0, 'Normal', { fg = colors.fg_main, bg = colors.bg_dark })
                hl(0, 'NormalFloat', { fg = colors.fg_main, bg = colors.bg_medium })
                hl(0, 'FloatBorder', { fg = colors.blue, bg = colors.bg_medium })
                hl(0, 'FloatTitle', { fg = colors.yellow, bg = colors.bg_medium, bold = true })
                hl(0, 'Cursor', { fg = colors.bg_dark, bg = colors.fg_main })
                hl(0, 'CursorLine', { bg = colors.bg_medium })
                hl(0, 'CursorLineNr', { fg = colors.yellow, bold = true })
                hl(0, 'LineNr', { fg = colors.bright_black })
                hl(0, 'Visual', { bg = colors.bg_highlight })
                hl(0, 'VisualNOS', { bg = colors.bg_highlight })
                hl(0, 'Search', { fg = colors.bg_dark, bg = colors.yellow })
                hl(0, 'IncSearch', { fg = colors.bg_dark, bg = colors.blue })
                hl(0, 'MatchParen', { fg = colors.bright_yellow, bold = true })

                hl(0, 'Comment', { fg = colors.bright_black, italic = true })
                hl(0, 'Constant', { fg = colors.bright_cyan })
                hl(0, 'String', { fg = colors.green })
                hl(0, 'Character', { fg = colors.green })
                hl(0, 'Number', { fg = colors.bright_cyan })
                hl(0, 'Boolean', { fg = colors.bright_cyan })
                hl(0, 'Float', { fg = colors.bright_cyan })
                hl(0, 'Identifier', { fg = colors.fg_main })
                hl(0, 'Function', { fg = colors.blue })
                hl(0, 'Statement', { fg = colors.purple })
                hl(0, 'Conditional', { fg = colors.purple })
                hl(0, 'Repeat', { fg = colors.purple })
                hl(0, 'Label', { fg = colors.red })
                hl(0, 'Operator', { fg = colors.cyan })
                hl(0, 'Keyword', { fg = colors.purple })
                hl(0, 'Exception', { fg = colors.red })
                hl(0, 'PreProc', { fg = colors.bright_red })
                hl(0, 'Include', { fg = colors.bright_red })
                hl(0, 'Define', { fg = colors.bright_red })
                hl(0, 'Macro', { fg = colors.bright_red })
                hl(0, 'PreCondit', { fg = colors.bright_red })
                hl(0, 'Type', { fg = colors.yellow })
                hl(0, 'StorageClass', { fg = colors.yellow })
                hl(0, 'Structure', { fg = colors.yellow })
                hl(0, 'Typedef', { fg = colors.yellow })
                hl(0, 'Special', { fg = colors.blue })
                hl(0, 'SpecialChar', { fg = colors.blue })
                hl(0, 'Tag', { fg = colors.purple })
                hl(0, 'Delimiter', { fg = colors.cyan })
                hl(0, 'SpecialComment', { fg = colors.bright_black, italic = true, bold = true })
                hl(0, 'Debug', { fg = colors.red })
                hl(0, 'Underlined', { underline = true })
                hl(0, 'Error', { fg = colors.red, bold = true })
                hl(0, 'Todo', { fg = colors.yellow, bold = true })

                hl(0, 'StatusLine', { fg = colors.fg_main, bg = colors.bg_light })
                hl(0, 'StatusLineNC', { fg = colors.bright_black, bg = colors.bg_medium })
                hl(0, 'TabLine', { fg = colors.bright_black, bg = colors.bg_light })
                hl(0, 'TabLineFill', { bg = colors.bg_medium })
                hl(0, 'TabLineSel', { fg = colors.yellow, bg = colors.bg_dark, bold = true })
                hl(0, 'Pmenu', { fg = colors.fg_main, bg = colors.bg_medium })
                hl(0, 'PmenuSel', { fg = colors.yellow, bg = colors.bg_light, bold = true })
                hl(0, 'PmenuSbar', { bg = colors.bg_light })
                hl(0, 'PmenuThumb', { bg = colors.red })
                hl(0, 'WildMenu', { fg = colors.bg_dark, bg = colors.blue })
                hl(0, 'VertSplit', { fg = colors.bg_highlight })
                hl(0, 'WinSeparator', { fg = colors.bg_highlight })
                hl(0, 'Folded', { fg = colors.bright_black, bg = colors.bg_medium })
                hl(0, 'FoldColumn', { fg = colors.blue, bg = colors.bg_dark })
                hl(0, 'SignColumn', { fg = colors.red, bg = colors.bg_dark })
                hl(0, 'ColorColumn', { bg = colors.bg_medium })

                hl(0, 'DiffAdd', { fg = colors.green, bg = colors.bg_medium })
                hl(0, 'DiffChange', { fg = colors.blue, bg = colors.bg_medium })
                hl(0, 'DiffDelete', { fg = colors.red, bg = colors.bg_medium })
                hl(0, 'DiffText', { fg = colors.yellow, bg = colors.bg_light, bold = true })

                hl(0, 'GitSignsAdd', { fg = colors.green })
                hl(0, 'GitSignsChange', { fg = colors.blue })
                hl(0, 'GitSignsDelete', { fg = colors.red })

                hl(0, 'DiagnosticError', { fg = colors.red })
                hl(0, 'DiagnosticWarn', { fg = colors.yellow })
                hl(0, 'DiagnosticInfo', { fg = colors.blue })
                hl(0, 'DiagnosticHint', { fg = colors.cyan })
                hl(0, 'DiagnosticUnderlineError', { undercurl = true, sp = colors.red })
                hl(0, 'DiagnosticUnderlineWarn', { undercurl = true, sp = colors.yellow })
                hl(0, 'DiagnosticUnderlineInfo', { undercurl = true, sp = colors.blue })
                hl(0, 'DiagnosticUnderlineHint', { undercurl = true, sp = colors.cyan })

                hl(0, 'LspReferenceText', { bg = colors.bg_light })
                hl(0, 'LspReferenceRead', { bg = colors.bg_light })
                hl(0, 'LspReferenceWrite', { bg = colors.bg_light, underline = true })

                hl(0, '@variable', { fg = colors.fg_main })
                hl(0, '@variable.builtin', { fg = colors.bright_cyan })
                hl(0, '@variable.parameter', { fg = colors.cyan })
                hl(0, '@variable.member', { fg = colors.blue })
                hl(0, '@constant', { fg = colors.bright_cyan })
                hl(0, '@constant.builtin', { fg = colors.bright_cyan })
                hl(0, '@constant.macro', { fg = colors.yellow })
                hl(0, '@module', { fg = colors.yellow })
                hl(0, '@module.builtin', { fg = colors.yellow })
                hl(0, '@label', { fg = colors.red })
                hl(0, '@string', { fg = colors.green })
                hl(0, '@string.escape', { fg = colors.blue })
                hl(0, '@string.special', { fg = colors.blue })
                hl(0, '@string.regexp', { fg = colors.bright_red })
                hl(0, '@character', { fg = colors.green })
                hl(0, '@character.special', { fg = colors.blue })
                hl(0, '@boolean', { fg = colors.bright_cyan })
                hl(0, '@number', { fg = colors.bright_cyan })
                hl(0, '@number.float', { fg = colors.bright_cyan })
                hl(0, '@type', { fg = colors.yellow })
                hl(0, '@type.builtin', { fg = colors.yellow })
                hl(0, '@type.definition', { fg = colors.yellow })
                hl(0, '@attribute', { fg = colors.bright_red })
                hl(0, '@property', { fg = colors.blue })
                hl(0, '@function', { fg = colors.blue })
                hl(0, '@function.builtin', { fg = colors.blue })
                hl(0, '@function.call', { fg = colors.blue })
                hl(0, '@function.macro', { fg = colors.bright_red })
                hl(0, '@function.method', { fg = colors.blue })
                hl(0, '@function.method.call', { fg = colors.blue })
                hl(0, '@constructor', { fg = colors.yellow })
                hl(0, '@operator', { fg = colors.cyan })
                hl(0, '@keyword', { fg = colors.purple })
                hl(0, '@keyword.coroutine', { fg = colors.purple })
                hl(0, '@keyword.function', { fg = colors.purple })
                hl(0, '@keyword.operator', { fg = colors.purple })
                hl(0, '@keyword.import', { fg = colors.bright_red })
                hl(0, '@keyword.conditional', { fg = colors.purple })
                hl(0, '@keyword.repeat', { fg = colors.purple })
                hl(0, '@keyword.return', { fg = colors.purple })
                hl(0, '@keyword.exception', { fg = colors.red })
                hl(0, '@comment', { fg = colors.bright_black, italic = true })
                hl(0, '@comment.documentation', { fg = colors.bright_black, italic = true })
                hl(0, '@punctuation', { fg = colors.cyan })
                hl(0, '@punctuation.bracket', { fg = colors.cyan })
                hl(0, '@punctuation.delimiter', { fg = colors.cyan })
                hl(0, '@punctuation.special', { fg = colors.blue })
                hl(0, '@tag', { fg = colors.purple })
                hl(0, '@tag.attribute', { fg = colors.yellow })
                hl(0, '@tag.delimiter', { fg = colors.cyan })

                hl(0, 'TelescopeBorder', { fg = colors.blue })
                hl(0, 'TelescopePromptBorder', { fg = colors.red })
                hl(0, 'TelescopeResultsBorder', { fg = colors.green })
                hl(0, 'TelescopePreviewBorder', { fg = colors.yellow })
                hl(0, 'TelescopeSelection', { fg = colors.yellow, bg = colors.bg_light, bold = true })
                hl(0, 'TelescopeMatching', { fg = colors.blue, bold = true })

                hl(0, 'NeoTreeNormal', { fg = colors.fg_main, bg = colors.bg_dark })
                hl(0, 'NeoTreeDirectoryName', { fg = colors.yellow })
                hl(0, 'NeoTreeDirectoryIcon', { fg = colors.blue })
                hl(0, 'NeoTreeFileName', { fg = colors.fg_main })
                hl(0, 'NeoTreeFileIcon', { fg = colors.cyan })
                hl(0, 'NeoTreeIndentMarker', { fg = colors.bg_highlight })
                hl(0, 'NeoTreeRootName', { fg = colors.purple, bold = true })
                hl(0, 'NeoTreeGitModified', { fg = colors.blue })
                hl(0, 'NeoTreeGitAdded', { fg = colors.green })
                hl(0, 'NeoTreeGitDeleted', { fg = colors.red })

                vim.g.terminal_color_0 = '#090300'
                vim.g.terminal_color_1 = '#ff1100'
                vim.g.terminal_color_2 = '#01a252'
                vim.g.terminal_color_3 = '#fded02'
                vim.g.terminal_color_4 = '#26bdfd'
                vim.g.terminal_color_5 = '#a16a94'
                vim.g.terminal_color_6 = '#b5e4f4'
                vim.g.terminal_color_7 = '#a5a2a2'
                vim.g.terminal_color_8 = '#5c5855'
                vim.g.terminal_color_9 = '#e8bbd0'
                vim.g.terminal_color_10 = '#3a3432'
                vim.g.terminal_color_11 = '#ff9494'
                vim.g.terminal_color_12 = '#807d7c'
                vim.g.terminal_color_13 = '#d6d5d4'
                vim.g.terminal_color_14 = '#cdab53'
                vim.g.terminal_color_15 = '#f7f7f7'
            end,
        },
    },
}
