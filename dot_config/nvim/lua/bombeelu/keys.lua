return setmetatable({}, {
  __index = function(t, k)
    local f = function(special)
      if special then
        k = string.format("<%s>", k)
      end
      nvim.feedkeys(nvim.replace_termcodes(k, true, false, true), "n", false)
    end
    rawset(t, k, f)

    return f
  end,
})
