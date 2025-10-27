local M = {}

local MAX_RECURSIVE_DEPTH = 69

M.basename = function(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

M.table_merge = function(t1, t2)
  local function merge(dst, src, depth)
    if depth > MAX_RECURSIVE_DEPTH then
      return dst
    end

    for k, v in pairs(src) do
      if type(v) == "table" then
        dst[k] = type(dst[k]) == "table" and dst[k] or {}
        merge(dst[k], v, depth + 1)
      else
        dst[k] = v
      end
    end
    return dst
  end

  return merge(t1, t2, 0)
end

return M
