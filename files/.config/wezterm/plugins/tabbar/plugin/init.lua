local wezterm = require("wezterm")
local util = require("util")

local M = {} -- wezterm.config_builder();

M.apply_to_config = function(config, _)
  -- https://wezterm.org/config/appearance.html#tab-bar-appearance-colors
  -- config.enable_tab_bar = true
  -- config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.tab_max_width = 16
end

-- VARIABLES
local tab_renames = {
  [""] = "-",
  sh = "-",
  dash = "-",
  bash = "-",
  fish = "-",
  zsh = "-",
}

-- Set tab title to process name
wezterm.on("format-tab-title", function(tab, tabs, panes, cfg, hover, max_width)
  local process_name = tab.active_pane.foreground_process_name
  process_name = process_name and util.basename(process_name) or ""

  if tab_renames[process_name] then
    process_name = tab_renames[process_name]
  end

  return string.format(" %d: %s ", tab.tab_index, process_name)
end)

-- config.status_update_interval = 1000
wezterm.on("update-right-status", function(window, pane)
  local time = wezterm.strftime(" %H:%M:%S ")
  local date = wezterm.strftime(" %d.%m.%Y")
  -- TODO: battery
  window:set_right_status(wezterm.format({
    { Foreground = { AnsiColor = "Teal" } },
    { Text = wezterm.nerdfonts.fa_clock_o },
    "ResetAttributes",
    { Text = time },
    { Foreground = { AnsiColor = "Teal" } },
    { Text = wezterm.nerdfonts.fa_calendar },
    "ResetAttributes",
    { Text = date },
  }))
end)

return M
