local M = {}

local MAX_RECURSIVE_DEPTH = 69

M.basename = function(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

M.abc_pairs = function(t, sort_f)
  local a = {}

  for n in pairs(t) do table.insert(a, n) end

  table.sort(a, sort_f)
  local i = 0
  local iter = function()
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
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

M.table_length = function(t)
  local l = 0
  for _ in ipairs(t) do l = l + 1 end
  return l
end

M.table_pretty = function(t)
  local function pretty(t, depth)
    local parts = {}
    local parts_count = 0

    for key, value in pairs(t) do
      local isTable = false

      parts_count = parts_count + 1

      if type(key) ~= "string" then key = tostring(key) end

      if type(value) == "table" then
        isTable = true
        if depth > MAX_RECURSIVE_DEPTH then
          value = "..."
        else
          value = pretty(value, depth + 1)
        end
      elseif type(value) == "string" then
        value = value
      else
        value = tostring(value)
      end

      if isTable then
        table.insert(parts, string.format("%s.%s", key, value))
      else
        table.insert(parts, string.format("%s = %s", key, value))
      end
    end

    if parts_count == 1 then
      return table.concat(parts, ",\n")
    else
      return string.format("{%s}", table.concat(parts, ", "))
    end
  end

  return pretty(t, 0)
end

M.key_simplifier = function(key)
  local simple_key = {
    key = key.key,
    action = key.action
  }

  if type(simple_key.action) == "table" then
    simple_key.action = M.table_pretty(simple_key.action)
  end

  if type(simple_key.action) ~= "string" then
    simple_key.action = "unknown"
  end

  if key.mods then
    simple_key.key = string.format("%s, %s", key.mods, key.key)
  end

  return simple_key
end

return M
