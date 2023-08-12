local M = {}

function M.feed(keys)
  local escaped_keys = {}
  local result

  if type(keys) == "table" then
    for _, val in ipairs(keys) do
      if string.len(val) > 1 then
        table.insert(escaped_keys, nvim.replace_termcodes(val, true, false, true))
      else
        table.insert(escaped_keys, val)
      end
    end

    result = table.concat(escaped_keys, "")
  else
    result = keys
  end

  nvim.feedkeys(result, "n", false)
end

return setmetatable(M, {
  __index = function(t, k)
    if vim.tbl_contains(t, k) then
      return t[k]
    else
      local f = function(special)
        if special then
          k = string.format("<%s>", k)
        end
        nvim.feedkeys(nvim.replace_termcodes(k, true, false, true), "n", false)
      end
      rawset(t, k, f)

      return f
    end
  end,
})
