-- Simple wrapper around https://github.com/tpope/vim-repeat

local api = vim.api
local M = {}

local repeat_fn

function M.repeat_action()
  repeat_fn()
end

function M.mk_repeatable(fn)
  return function(...)
    local args = { ... }
    local nargs = select("#", ...)
    repeat_fn = function()
      fn(unpack(args, 1, nargs))
      local vimfn = vim.fn
      local sequence = string.format("%sRepeat", api.nvim_replace_termcodes("<Plug>", true, true, true))
      pcall(vimfn["repeat#set"], sequence, -1)
    end

    repeat_fn()
  end
end

vim.keymap.set("n", "<Plug>Repeat", function()
  M.repeat_action()
end, { noremap = false, silent = true })

return M
