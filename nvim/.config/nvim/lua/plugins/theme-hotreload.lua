return {
  {
    name = "theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"
      local preview_path = vim.fn.expand("~/.cache/dhms/nvim-live/preview.json")
      local unmodified, last_raw = {}, nil
      local preview = {
        Normal = { fg = "foreground", bg = "background" },
        NormalNC = { fg = "foreground", bg = "background" },
        NormalFloat = { fg = "foreground", bg = "surface" },
        WinSeparator = { fg = "border" }, FloatBorder = { fg = "border" },
        LineNr = { fg = "muted" }, CursorLine = { bg = "surface" },
        Visual = { fg = "selectionText", bg = "selection" },
        Comment = { fg = "muted" }, String = { fg = "green" },
        Constant = { fg = "orange" }, Function = { fg = "blue" },
        Identifier = { fg = "foreground" }, Statement = { fg = "magenta" },
        Type = { fg = "cyan" }, Special = { fg = "yellow" },
        DiffAdd = { bg = "addBg" }, DiffDelete = { bg = "removeBg" },
        DiagnosticError = { fg = "red" }, DiagnosticWarn = { fg = "yellow" },
        DiagnosticInfo = { fg = "blue" }, DiagnosticHint = { fg = "cyan" },
      }

      local function restore_preview()
        for name, original in pairs(unmodified) do
          vim.api.nvim_set_hl(0, name, original)
        end
        unmodified = {}
      end

      local function update_preview()
        local raw = ""
        local file = io.open(preview_path, "r")
        if file then
          raw = file:read("*a") or ""
          file:close()
        end
        if raw == last_raw then return end
        last_raw = raw
        if raw == "" then
          restore_preview()
          return
        end
        local ok, palette = pcall(vim.json.decode, raw)
        if not ok or type(palette) ~= "table" then return end
        for name, colors in pairs(preview) do
          if not unmodified[name] then
            unmodified[name] = vim.api.nvim_get_hl(0, { name = name, create = false })
          end
          local current = vim.api.nvim_get_hl(0, { name = name, link = false, create = false })
          for attr, token in pairs(colors) do
            -- Keep unset backgrounds transparent and keep typography flags.
            if current[attr] or attr ~= "bg" then
              current[attr] = palette[token]
            end
          end
          vim.api.nvim_set_hl(0, name, current)
        end
      end

      local timer = vim.uv.new_timer()
      if timer then
        timer:start(0, 250, vim.schedule_wrap(update_preview))
        vim.api.nvim_create_autocmd("VimLeavePre", { callback = function() timer:close() end })
      end
      vim.api.nvim_create_autocmd("ColorScheme", { callback = function()
        unmodified, last_raw = {}, nil
      end })

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyReload",
        callback = function()
          -- Unload the theme module
          package.loaded["plugins.theme"] = nil

          vim.schedule(function()
            local ok, theme_spec = pcall(require, "plugins.theme")
            if not ok then
              return
            end

            -- Find the theme plugin and unload it
            local theme_plugin_name = nil
            for _, spec in ipairs(theme_spec) do
              if spec[1] and spec[1] ~= "LazyVim/LazyVim" then
                theme_plugin_name = spec.name or spec[1]
                break
              end
            end

            -- Clear all highlight groups before applying new theme
            vim.cmd("highlight clear")
            if vim.fn.exists("syntax_on") then
              vim.cmd("syntax reset")
            end

            -- Reset background to default so colorscheme can set it properly (light themes will set to light)
            vim.o.background = "dark"

            -- Unload theme plugin modules to force full reload
            if theme_plugin_name then
              local plugin = require("lazy.core.config").plugins[theme_plugin_name]
              if plugin then
                -- Unload all lua modules from the plugin directory
                local plugin_dir = plugin.dir .. "/lua"
                require("lazy.core.util").walkmods(plugin_dir, function(modname)
                  package.loaded[modname] = nil
                  package.preload[modname] = nil
                end)
              end
            end

            -- Find and apply the new colorscheme
            for _, spec in ipairs(theme_spec) do
              if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
                local colorscheme = spec.opts.colorscheme

                -- Load the colorscheme plugin
                require("lazy.core.loader").colorscheme(colorscheme)

                vim.defer_fn(function()
                  -- Apply the colorscheme (it will set background itself)
                  pcall(vim.cmd.colorscheme, colorscheme)

                  -- Force redraw to update all UI elements
                  vim.cmd("redraw!")

                  -- Reload transparency settings
                  if vim.fn.filereadable(transparency_file) == 1 then
                    vim.defer_fn(function()
                      vim.cmd.source(transparency_file)

                      -- Trigger UI updates for various plugins
                      vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
                      vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })

                      -- Final redraw
                      vim.cmd("redraw!")
                    end, 5)
                  end
                end, 5)

                break
              end
            end
          end)
        end,
      })
    end,
  },
}
