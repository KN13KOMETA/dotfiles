local wezterm = require("wezterm")
local config = wezterm.config_builder()

local timeout = 3333

local launcher_key = "l"
local workspace_key = "w"
local tab_key = "t"
local new_key = "n"
local close_key = "c"
local rename_key = "r"
local direction_key = {
  up = "k",
  down = "j",
  left = "h",
  right = "l",
}

config.leader = { key = "Space", mods = "CTRL", timeout_milliseconds = timeout }
config.keys = {
  { key = "[", mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "prev" }) },
  { key = "]", mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "next" }) },
  { key = workspace_key, mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "workspace" }) },
  { key = tab_key, mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "tab" }) },
  { key = launcher_key, mods = "LEADER", action = wezterm.action.ShowLauncher },
}
config.key_tables = {
  prev = {
    { key = tab_key, action = wezterm.action.ActivateTabRelative(-1) },
  },
  next = {
    { key = tab_key, action = wezterm.action.ActivateTabRelative(1) },
  },
  tab = {
    { key = launcher_key, action = wezterm.action.ShowLauncherArgs({ flags = "TABS" }) },
    { key = new_key, action = wezterm.action.SpawnTab("CurrentPaneDomain") },
    { key = close_key, action = wezterm.action.CloseCurrentTab({ confirm = true }) },
  },
  workspace = {
    { key = launcher_key, action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
    {
      key = rename_key,
      action = wezterm.action.PromptInputLine({
        description = wezterm.format({
          { Attribute = { Intensity = "Bold" } },
          { Foreground = { AnsiColor = "Fuchsia" } },
          { Text = "Renaming Tab Title...:" },
        }),
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            wezterm.mux.rename_workspace(window:active_workspace(), line)
          end
        end),
      }),
    },
  },
}

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

-- Maximize window on startup
wezterm.on("gui-startup", function()
  local tab, pane, window = wezterm.mux.spawn_window({})
  window:gui_window():maximize()
end)

return config
