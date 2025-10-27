local wezterm = require("wezterm")
local util = require("util")

local M = {}

-- Leader key
local leader = {
  key = "Space",
  mods = "CTRL",
  timeout = 3333,
}

local key = {
  -- Target keys
  launcher = "l",
  window = "w",
  workspace = "o",
  tab = "t",
  -- Action keys
  new = "n",
  close = "c",
  rename = "r",
  -- Special keys
  prev = "[",
  next = "]",
  direction = {
    up = "k",
    down = "j",
    left = "h",
    right = "l",
  },
}

M.apply_to_config = function(config, _)
  local timeout = 3333

  config.leader = { key = leader.key, mods = leader.mods, timeout_milliseconds = leader.timeout }
  config.keys = {
    { key = key.prev,      mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "prev" }) },
    { key = key.next,      mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "next" }) },
    { key = key.workspace, mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "workspace" }) },
    { key = key.tab,       mods = "LEADER", action = wezterm.action.ActivateKeyTable({ name = "tab" }) },
    { key = key.launcher,  mods = "LEADER", action = wezterm.action.ShowLauncher },
  }
  config.key_tables = {
    prev = {
      { key = key.tab, action = wezterm.action.ActivateTabRelative(-1) },
    },
    next = {
      { key = key.tab, action = wezterm.action.ActivateTabRelative(1) },
    },
    tab = {
      { key = key.launcher, action = wezterm.action.ShowLauncherArgs({ flags = "TABS" }) },
      { key = key.new,      action = wezterm.action.SpawnTab("CurrentPaneDomain") },
      { key = key.close,    action = wezterm.action.CloseCurrentTab({ confirm = true }) },
    },
    workspace = {
      { key = key.launcher, action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
      {
        key = key.rename,
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
