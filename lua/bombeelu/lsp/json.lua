local lspconfig = require("lspconfig")

local json = {}

function json.setup(opts)
  lspconfig.jsonls.setup({
    on_attach = opts.on_attach,
    capabilities = opts.capabilities,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  })
end

return json
