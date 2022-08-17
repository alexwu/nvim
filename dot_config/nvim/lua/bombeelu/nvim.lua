-- the following is from here: https://github.com/norcalli/nvim.lua/blob/master/lua/nvim.lua
_G.nvim = setmetatable({
  buf = {
    line = vim.api.nvim_get_current_line,
    nr = vim.api.nvim_get_current_buf,
  },
  ex = setmetatable({}, {
    __index = function(t, k)
      local command = k:gsub("_$", "!")
      local f = function(...)
        return vim.api.nvim_command(table.concat(vim.tbl_flatten({ command, ... }), " "))
      end
      rawset(t, k, f)
      return f
    end,
  }),
}, {
  __index = function(t, k)
    local f = vim.api["nvim_" .. k]
    if f then
      rawset(t, k, f)
    end
    return f
  end,
})
