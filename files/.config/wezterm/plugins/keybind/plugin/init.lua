local wezterm = require("wezterm")
local util = require("util")

local M = {}

M.apply_to_config = function(config, _)
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
    { key = "[",           mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "prev" }) },
    { key = "]",           mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "next" }) },
    { key = workspace_key, mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "workspace" }) },
    { key = tab_key,       mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "tab" }) },
    { key = launcher_key,  mods = "LEADER", action = wezterm.action.ShowLauncher },
    {
      key = "a",
      mods = "LEADER",
      action = wezterm.action.AttachDomain("unix"),
    },
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
      { key = new_key,      action = wezterm.action.SpawnTab("CurrentPaneDomain") },
      { key = close_key,    action = wezterm.action.CloseCurrentTab({ confirm = true }) },
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
end

return M
