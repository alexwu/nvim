local M = {}

M.format = require("ruby").format

function M.setup(opts)
  require("ruby").setup({
    sorbet = {
      experimental = true,
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
    },
  })
end

return M
