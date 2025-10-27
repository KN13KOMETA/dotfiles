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
  move_left = "<",
  move_right = ">",
  direction = {
    up = "k",
    down = "j",
    left = "h",
    right = "l",
  },
}

M.apply_to_config = function(config, opts)
  if type(opts) ~= "table" then
    opts = {
      leader = {},
      key = {},
    }
  end

  leader = util.table_merge(leader, opts.leader or {})
  key = util.table_merge(key, opts.key or {})

  config.leader = { key = leader.key, mods = leader.mods, timeout_milliseconds = leader.timeout }

  config.keys = {
    -- Target
    { key = key.launcher,   mods = "LEADER",       action = wezterm.action.ShowLauncher },
    { key = key.workspace,  mods = "LEADER",       action = wezterm.action.ActivateKeyTable({ name = "workspace" }) },
    { key = key.tab,        mods = "LEADER",       action = wezterm.action.ActivateKeyTable({ name = "tab" }) },
    -- Special
    { key = key.prev,       mods = "LEADER",       action = wezterm.action.ActivateKeyTable({ name = "prev" }) },
    { key = key.next,       mods = "LEADER",       action = wezterm.action.ActivateKeyTable({ name = "next" }) },
    -- TODO: shift is theoretically isnt required, but since key is defined as "<" and ">" shift is required to press these
    -- TODO: but if i want to change it to something that doesnt require shift, is still must press shift
    { key = key.move_left,  mods = "LEADER|SHIFT", action = wezterm.action.ActivateKeyTable({ name = "move_left" }) },
    { key = key.move_right, mods = "LEADER|SHIFT", action = wezterm.action.ActivateKeyTable({ name = "move_right" }) },
  }

  config.key_tables = {
    -- Target
    workspace = {
      { key = key.launcher, action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
      { key = key.new,      action = wezterm.action.SwitchToWorkspace({}) },
      {
        key = key.rename,
        action = wezterm.action.PromptInputLine({
          description = wezterm.format({
            { Attribute = { Intensity = "Bold" } },
            { Text = "Renaming Workspace:" },
          }),
          action = wezterm.action_callback(function(window, pane, line)
            if line then
              wezterm.mux.rename_workspace(window:active_workspace(), line)
            end
          end),
        }),
      },
    },
    tab = {
      { key = key.launcher, action = wezterm.action.ShowLauncherArgs({ flags = "TABS" }) },
      { key = key.new,      action = wezterm.action.SpawnTab("CurrentPaneDomain") },
      { key = key.close,    action = wezterm.action.CloseCurrentTab({ confirm = true }) },
      {
        key = key.rename,
        action = wezterm.action.PromptInputLine({
          description = wezterm.format({
            { Attribute = { Intensity = "Bold" } },
            { Text = "Renaming Tab:" },
          }),
          action = wezterm.action_callback(function(window, pane, line)
            if line then
              window:active_tab():set_title(line)
            end
          end),
        }),
      },
    },
    -- Special
    prev = {
      { key = key.tab, action = wezterm.action.ActivateTabRelative(-1) },
    },
    next = {
      { key = key.tab, action = wezterm.action.ActivateTabRelative(1) },
    },
    move_left = {
      { key = key.tab, action = wezterm.action.MoveTabRelative(-1) },
    },
    move_right = {
      { key = key.tab, action = wezterm.action.MoveTabRelative(1) },
    },
  }
end

return M
