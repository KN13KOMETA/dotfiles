local wezterm = require("wezterm")

local M = {}

M.apply_to_config = function(config, opts)
  if type(opts) ~= "table" then opts = {} end

  if type(opts.key) ~= "string" then
    opts.key = "h"
  end
  if type(opts.mods) ~= "string" then
    opts.mods = "CTRL|SHIFT"
  end
  if type(opts.text) ~= "string" then
    opts.text = "Help screen text"
  end

  if type(config.keys) ~= "table" then
    config.keys = {}
  end


  table.insert(config.keys, {
    key = opts.key,
    mods = opts.mods,
    action = wezterm.action.PromptInputLine {
      description = opts.text,
      action = wezterm.action_callback(function() end)
    }
  })
end

return M
