--[[
Theme Stats Plugin
Author: OldJobobo (https://github.com/OldJobobo)
]]

local uv = vim.uv or vim.loop

local function basename(repo)
  local name = repo:match("/([^/]+)$") or repo
  return name:gsub("%.git$", "")
end

local function format_bytes(bytes)
  local units = { "B", "KB", "MB", "GB", "TB" }
  local size = bytes
  local unit = 1
  while size >= 1024 and unit < #units do
    size = size / 1024
    unit = unit + 1
  end
  if unit == 1 then
    return string.format("%d %s", size, units[unit])
  end
  return string.format("%.2f %s", size, units[unit])
end

local function dir_size(path)
  local stat = uv.fs_stat(path)
  if not stat then
    return nil
  end
  if stat.type == "file" then
    return stat.size or 0
  end
  if stat.type ~= "directory" then
    return 0
  end

  local total = 0
  local stack = { path }

  while #stack > 0 do
    local current = table.remove(stack)
    local req = uv.fs_scandir(current)
    if req then
      while true do
        local name, entry_type = uv.fs_scandir_next(req)
        if not name then
          break
        end
        local full = current .. "/" .. name
        if entry_type == "directory" then
          stack[#stack + 1] = full
        else
          local file_stat = uv.fs_stat(full)
          if file_stat and file_stat.size then
            total = total + file_stat.size
          end
        end
      end
    end
  end

  return total
end

local function read_theme_specs()
  local path = vim.fn.stdpath("config") .. "/lua/plugins/all-themes.lua"
  local ok, data = pcall(dofile, path)
  if not ok then
    return nil, ("failed to load %s: %s"):format(path, data)
  end
  if type(data) ~= "table" then
    return nil, ("unexpected return type from %s"):format(path)
  end

  local specs = {}
  for _, spec in ipairs(data) do
    if type(spec) == "table" and type(spec[1]) == "string" then
      specs[#specs + 1] = {
        repo = spec[1],
        name = spec.name or basename(spec[1]),
      }
    end
  end
  return specs
end

local function find_plugin_meta(repo, name)
  local ok, cfg = pcall(require, "lazy.core.config")
  if not ok or type(cfg.plugins) ~= "table" then
    return nil
  end

  if cfg.plugins[name] then
    return cfg.plugins[name]
  end

  for _, plugin in pairs(cfg.plugins) do
    if type(plugin) == "table" then
      local plugin_repo = plugin[1]
      if plugin_repo == repo then
        return plugin
      end
      if type(plugin.url) == "string" and plugin.url:find(repo, 1, true) then
        return plugin
      end
    end
  end

  return nil
end

local function gather_stats()
  local specs, err = read_theme_specs()
  if not specs then
    return nil, err
  end

  local lazy_root = vim.fn.stdpath("data") .. "/lazy"
  local stats = {
    total = #specs,
    installed = 0,
    missing = 0,
    total_bytes = 0,
    themes = {},
  }

  for _, item in ipairs(specs) do
    local plugin = find_plugin_meta(item.repo, item.name)
    local dir = (plugin and plugin.dir) or (lazy_root .. "/" .. item.name)
    local bytes = dir_size(dir)
    local installed = bytes ~= nil

    if installed then
      stats.installed = stats.installed + 1
      stats.total_bytes = stats.total_bytes + bytes
    else
      stats.missing = stats.missing + 1
      bytes = 0
    end

    stats.themes[#stats.themes + 1] = {
      repo = item.repo,
      name = item.name,
      dir = dir,
      bytes = bytes,
      installed = installed,
    }
  end

  table.sort(stats.themes, function(a, b)
    return a.bytes > b.bytes
  end)

  return stats
end

local function make_summary(stats)
  local largest = stats.themes[1]
  local avg = stats.installed > 0 and math.floor(stats.total_bytes / stats.installed) or 0
  local lines = {
    "Theme stats from plugins/all-themes.lua",
    ("Total themes: %d"):format(stats.total),
    ("Installed locally: %d"):format(stats.installed),
    ("Missing/not installed: %d"):format(stats.missing),
    ("Total disk usage: %s"):format(format_bytes(stats.total_bytes)),
    ("Average size (installed): %s"):format(format_bytes(avg)),
  }
  if largest then
    lines[#lines + 1] = ("Largest theme: %s (%s)"):format(largest.name, format_bytes(largest.bytes))
  end
  return lines
end

local function show_report(stats, show_all)
  local lines = make_summary(stats)
  lines[#lines + 1] = ""
  lines[#lines + 1] = show_all and "Per-theme sizes (largest first):" or "Top theme sizes (largest first):"

  local limit = show_all and #stats.themes or math.min(#stats.themes, 20)
  for i = 1, limit do
    local theme = stats.themes[i]
    lines[#lines + 1] = ("- %-24s %9s  %s"):format(
      theme.name,
      format_bytes(theme.bytes),
      theme.installed and "installed" or "missing"
    )
  end
  if not show_all and #stats.themes > limit then
    lines[#lines + 1] = ""
    lines[#lines + 1] = ("Showing %d of %d themes. Run :ThemeStats full to show all."):format(limit, #stats.themes)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "markdown"

  local width = math.min(math.floor(vim.o.columns * 0.9), 140)
  local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.85))
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2) - 1,
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Theme Stats ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true, nowait = true })

  vim.keymap.set("n", "r", function()
    local refreshed, err = gather_stats()
    if not refreshed then
      vim.notify(err, vim.log.levels.ERROR, { title = "ThemeStats" })
      return
    end
    show_report(refreshed, show_all)
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, silent = true, nowait = true })
end

if not vim.g.theme_stats_command_loaded then
  vim.g.theme_stats_command_loaded = true
  vim.api.nvim_create_user_command("ThemeStats", function(opts)
    local stats, err = gather_stats()
    if not stats then
      vim.notify(err, vim.log.levels.ERROR, { title = "ThemeStats" })
      return
    end

    show_report(stats, opts.args == "full")
  end, {
    nargs = "?",
    complete = function()
      return { "full" }
    end,
    desc = "Show stats for themes listed in plugins/all-themes.lua",
  })
end

return {}

--  ______   __       ______
-- /_____/\ /_/\     /_____/\
-- \:::_ \ \\:\ \    \:::_ \ \
--  \:\ \ \ \\:\ \    \:\ \ \ \
--   \:\ \ \ \\:\ \____\:\ \ \ \
--    \:\_\ \ \\:\/___/\\:\/.:| |
--  ___\_____\/_\_____\/ \____/_/  ______    _______   ______
-- /________/\/_____/\ /_______/\ /_____/\ /_______/\ /_____/\
-- \__.::.__\/\:::_ \ \\::: _  \ \\:::_ \ \\::: _  \ \\:::_ \ \
--   /_\::\ \  \:\ \ \ \\::(_)  \/_\:\ \ \ \\::(_)  \/_\:\ \ \ \
--   \:.\::\ \  \:\ \ \ \\::  _  \ \\:\ \ \ \\::  _  \ \\:\ \ \ \
--    \: \  \ \  \:\_\ \ \\::(_)  \ \\:\_\ \ \\::(_)  \ \\:\_\ \ \
--     \_____\/   \_____\/ \_______\/ \_____\/ \_______\/ \_____\/
--
