local defaults = require("plugins.lsp.defaults")
local M = {}

M.format = require("ruby").format

function M.setup(opts)
  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)
  local capabilities = vim.F.if_nil(o.capabilities, defaults.capabilities)

  require("ruby").setup({
    sorbet = {
      enable = true,
      experimental = true,
      rubyfmt_path = vim.fs.normalize("~/.bin/rubyfmt"),
      on_attach = on_attach,
      capabilities = capabilities,
    },
    ruby_lsp = {
      enable = true,
      use_bundler = true,
      on_attach = on_attach,
      capabilities = capabilities,
    },
  })
end

return M
