local wezterm = require("wezterm")
local config = wezterm.config_builder()

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
config.window_decorations = "RESIZE"

-- https://wezterm.org/config/lua/config/default_workspace.html
config.default_workspace = "main"

local tabbar_plugin = require("plugins/tabbar/plugin")

tabbar_plugin.apply_to_config(config, {})

return config
