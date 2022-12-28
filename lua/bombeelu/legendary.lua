local M = {}

function M.setup()
  require("legendary").setup({})

  key.map("<C-S-p>", vim.cmd.Legendary)
end

return M
