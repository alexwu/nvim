local defaults = require("plugins.lsp.defaults")

local function setup(opts)
  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)
  require("clangd_extensions").setup({
    server = {
      on_attach = on_attach,
    },
    extensions = {
      autoSetHints = false,
    },
  })
end

return { setup = setup }
