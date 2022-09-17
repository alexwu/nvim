local lspconfig = require("lspconfig")

local M = {}

function M.setup(opts)
  lspconfig.relay_lsp.setup(opts)
end

return M
