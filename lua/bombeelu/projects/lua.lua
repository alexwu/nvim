local Project = require("bombeelu.projects")

local Lua = Project:extend()

function Lua:new(opts)
  Lua.super.new(self, opts)
end

function Lua:resolve_root()
  return vim.fs.dirname(
    vim.fs.find(
      { "lua", ".git" },
      { upward = true, stop = vim.loop.os_homedir(), type = "directory", path = vim.api.nvim_buf_get_name(0) }
    )[1]
  )
end

function Lua:should_attach(bufnr)
  vim.pretty_print(self:root_dir())
end

function Lua:attach(bufnr)
  self:should_attach(bufnr)

  bufnr = bufnr or vim.api.nvim_get_current_buf()
end

function Lua:format() end

return Lua
