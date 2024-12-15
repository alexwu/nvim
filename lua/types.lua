---@meta

---@class vim.api.create_autocmd.callback.args
---@field id number
---@field event string
---@field group number?
---@field match string
---@field buf number
---@field file string
---@field data any

---@class vim.api.keyset.create_autocmd.opts: vim.api.keyset.create_autocmd
---@field callback? fun(ev:vim.api.create_autocmd.callback.args):boolean?

--- @param event any (string|array) Event(s) that will trigger the handler
--- @param opts vim.api.keyset.create_autocmd
--- @return integer
function nvim.create_autocmd(event, opts) end

---@param name string
---@param opts vim.api.keyset.create_augroup
--- @return integer
function nvim.create_augroup(name, opts) end

---@param name string
---@param command any
---@param opts vim.api.keyset.user_command
function nvim.create_user_command(name, command, opts) end

---@param bufnr integer
---@param name string
---@param command any
---@param opts vim.api.keyset.user_command
function nvim.buf_create_user_command(bufnr, name, command, opts) end

function nvim.feedkeys(keys, mode, escape) end

function nvim.replace_termcodes(str, from_part, do_lt, special) end
