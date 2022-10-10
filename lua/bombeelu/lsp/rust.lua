local defaults = require("plugins.lsp.defaults")

local M = {}

function M.setup(opts)
  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)

  require("rust-tools").setup({
    tools = {
      executor = require("rust-tools/executors").toggleterm,
      inlay_hints = {
        auto = false,
      },
      on_initialized = function()
        -- ih.set_all()
      end,
    },
    server = {
      on_attach = on_attach,
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
