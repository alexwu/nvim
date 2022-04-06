local Path = require("plenary.Path")

local parent = Path:new(vim.api.nvim_buf_get_name(0)):parent()
local p = Path:new(vim.api.nvim_buf_get_name(0))

vim.pretty_print(parent:absolute())

vim.pretty_print(p:parent():make_relative(parent.filename))
