local ih = require("inlay-hints")
local M = {}

function M.setup(opts)
  require("rust-tools").setup({
    tools = {
      executor = require("rust-tools/executors").toggleterm,
      inlay_hints = {
        auto = false,
      },
      on_initialized = function()
        ih.set_all()
      end,
    },
    server = {
      on_attach = function(c, b)
        opts.on_attach(c, b)
        ih.on_attach(c, b)

        -- key.map("J", function()
        --   require("rust-tools.join_lines").join_lines()
        -- end, { modes = "x", buffer = b })
      end,
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = true,
            disabled = { "unresolved-proc-macro" },
            enableExperimental = false,
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
