local Terminal = require("toggleterm.terminal").Terminal

local M = {}

function M.setup()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_create_user_command(bufnr, "Just", function()
    M.just()
  end, {})
end

function M.just()
  Terminal:new({
    cmd = "just",
    hidden = false,
    start_in_insert = false,
  }):toggle()
end

return M
