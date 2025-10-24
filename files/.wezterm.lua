local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- UTILS
local util = {}

util.basename = function(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
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

-- TAB BAR
-- https://wezterm.org/config/appearance.html#tab-bar-appearance-colors
-- config.enable_tab_bar = true
-- config.hide_tab_bar_if_only_one_tab = false
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 16

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

-- OPACITY
-- https://wezterm.org/config/appearance.html#window-background-opacity
config.window_background_opacity = 0.75
-- https://wezterm.org/config/appearance.html#text-background-opacity
config.text_background_opacity = 0.75

-- FONT
-- https://wezterm.org/config/fonts.html#font-related-configuration
config.font = wezterm.font("0xProto Nerd Font Mono")
-- https://wezterm.org/config/fonts.html#font-related-options
config.font_size = 11.2

-- https://wezterm.org/config/lua/config/window_decorations.html
config.window_decorations = "NONE"

return config
