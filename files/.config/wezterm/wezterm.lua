local wezterm = require("wezterm")
local config = wezterm.config_builder()
local util = require("util")

-- OPACITY
-- https://wezterm.org/config/appearance.html#window-background-opacity
config.window_background_opacity = 0.75
-- https://wezterm.org/config/appearance.html#text-background-opacity
config.text_background_opacity = 0.75

-- FONT
-- https://wezterm.org/config/fonts.html#font-related-configuration
config.font = wezterm.font("IntoneMono NF")
-- https://wezterm.org/config/fonts.html#font-related-options
config.font_size = 11.2

-- https://wezterm.org/config/lua/config/window_decorations.html
config.window_decorations = "RESIZE"

-- https://wezterm.org/config/lua/config/default_workspace.html
config.default_workspace = "main"

-- Maximize window on startup
wezterm.on("gui-startup", function()
  local tab, pane, window = wezterm.mux.spawn_window({})
  window:gui_window():maximize()
end)

local plugin = {
  keybind = require("plugins/keybind/plugin"),
  tabbar = require("plugins/tabbar/plugin"),
  helpscreen = require("plugins/helpscreen/plugin")
}

-- TODO: panes and copy mode
plugin.keybind.apply_to_config(config, {})
plugin.tabbar.apply_to_config(config, {})

-- Init helpscreen plugin, keep at at bottom after every key and key_tables defined
do
  local keys_help = {}
  local simple_key = nil

  if type(config.leader) == "table" then
    simple_key = util.key_simplifier(config.leader)
    table.insert(keys_help, string.format("%s = LEADER", simple_key.key))
  end

  for _, key in ipairs(config.keys) do
    simple_key = util.key_simplifier(key)
    table.insert(keys_help, string.format("%s = %s", simple_key.key, simple_key.action))
  end

  for key_table_name, key_table in util.abc_pairs(config.key_tables) do
    table.insert(keys_help, string.format("> KEY TABLE: %s", key_table_name))
    for _, key in ipairs(key_table) do
      simple_key = util.key_simplifier(key)
      table.insert(keys_help, string.format("%s = %s", simple_key.key, simple_key.action))
    end
  end

  plugin.helpscreen.apply_to_config(config, {
    mods = "LEADER",
    text = wezterm.format({
      { Attribute = { Intensity = "Bold" } },
      { Foreground = { AnsiColor = "Purple" } },
      { Text = "> HELP SCREEN (WEZTERM KOMETA CONFIG)\n" },
      "ResetAttributes",
      { Text = "\n> KEYS\n" },
      { Text = table.concat(keys_help, "\n") },
      "ResetAttributes",
      { Text = "\n\nPress enter to close..." }
    })
  })
end

wezterm.on("window-resized", function(window, pane)
  wezterm.reload_configuration();
end)

return config
