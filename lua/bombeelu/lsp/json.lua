local json = {}

function json.setup(opts)
  vim.lsp.config("jsonls", {
    -- on_attach = opts.on_attach,
    -- capabilities = opts.capabilities,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
      },
    },
  })
  vim.lsp.enable("jsonls")
end

return json
