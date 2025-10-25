local M = {}

M.basename = function(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

return M
