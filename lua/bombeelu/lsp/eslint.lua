local lspconfig = require("lspconfig")

local eslint = {}
function eslint.setup(opts)
  lspconfig.eslint.setup({
    on_attach = opts.on_attach,
    capabilities = opts.capabilities,
    settings = {
      format = { enable = false },
      rulesCustomizations = { { rule = "*", severity = "warn" } },
    },
  })
end

return eslint
