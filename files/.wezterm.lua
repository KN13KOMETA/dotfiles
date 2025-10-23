local wezterm = require("wezterm")
local config = wezterm.config_builder();



-- TAB BAR
-- https://wezterm.org/config/appearance.html#tab-bar-appearance-colors
-- config.enable_tab_bar = false
-- config.hide_tab_bar_if_only_one_tab = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 16



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
