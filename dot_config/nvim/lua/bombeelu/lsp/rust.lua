local M = {}

function M.setup(opts)
  require("rust-tools").setup({
    tools = {
      executor = require("rust-tools/executors").toggleterm,
    },
    server = {
      on_attach = opts.on_attach,
      -- capabilities = opts.capabilities,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = true,
            -- disabled = { "unresolved-proc-macro" },
            enableExperimental = true,
          },
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  })
end

return M
