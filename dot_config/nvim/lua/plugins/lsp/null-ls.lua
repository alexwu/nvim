local lspconfig = require "lspconfig"
local null_ls = require "null-ls"
local on_attach = require("plugins.lsp.defaults").on_attach

local M = {}

M.setup = function(opts)
  opts = opts or {}

  null_ls.config {
    sources = {
      null_ls.builtins.diagnostics.rubocop.with {
        command = "bundle",
        args = { "exec", "rubocop", "-f", "json", "--stdin", "$FILENAME" },
      },
    },
  }

  lspconfig["null-ls"].setup { on_attach = on_attach, autostart = false }
end

return M
