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
      capabilities = opts.capabilities,
      settings = {
        ["rust-analyzer"] = {
          diagnostics = {
            enable = true,
            disabled = { "unresolved-proc-macro" },
            experimental = {
              enable = false,
            },
          },
          checkOnSave = {
            command = "clippy",
          },
          cargo = { features = "all" },
        },
      },
    },
    dap = {
      adapter = {
        type = "executable",
        command = "lldb-vscode",
        name = "rt_lldb",
      },
    },
  })
end

return M
