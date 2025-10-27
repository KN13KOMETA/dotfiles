local wezterm = require("wezterm")
local util = require("util")

local M = {}

M.apply_to_config = function(config, _)
  -- https://wezterm.org/config/appearance.html#tab-bar-appearance-colors
  -- config.enable_tab_bar = true
  -- config.hide_tab_bar_if_only_one_tab = false
  config.tab_bar_at_bottom = true
  config.use_fancy_tab_bar = false
  config.tab_max_width = 16

  -- config.status_update_interval = 1000
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
  local title = tab.tab_title

  if title == "" then
    title = tab.active_pane.foreground_process_name
    title = title and util.basename(title) or ""

    if tab_renames[title] then
      title = tab_renames[title]
    end
  end

  return string.format(" %d: %s ", tab.tab_index, title)
end)

-- Set status bar
wezterm.on("update-status", function(window, pane)
  -- Set left status
  do
    local text = window:active_key_table()

    if text then
      text = wezterm.nerdfonts.fa_compress .. " " .. text
    elseif window:leader_is_active() then
      text = wezterm.nerdfonts.fa_compress .. " leader"
    else
      text = window:active_workspace()
    end

    window:set_left_status(string.format(" %s ", text))
  end
  -- Set right status
  do
    local time = wezterm.strftime(" %H:%M:%S ")
    local battery = {
      charge = wezterm.battery_info().state_of_charge,
      color = "Green",
      text = "",
    }

    if battery.charge ~= nil then
      if battery.charge < 0.25 then
        battery.color = "Red"
      elseif battery.charge < 0.75 then
        battery.color = "Yellow"
      end

      battery.text = wezterm.format({
        { Foreground = { AnsiColor = battery.color } },
        { Text = wezterm.nerdfonts.fa_bolt },
        "ResetAttributes",
        { Text = string.format(" %d%%  ", battery.charge * 100) },
      })
    end

    window:set_right_status(battery.text .. wezterm.format({
      { Foreground = { AnsiColor = "Teal" } },
      { Text = wezterm.nerdfonts.fa_clock_o },
      "ResetAttributes",
      { Text = time },
    }))
  end
end)

return M
