local M = {}

M.format = require("ruby").format

function M.setup(opts)
  require("ruby").setup({
    sorbet = {
      enable = true,
      experimental = true,
      rubyfmt_path = vim.fs.normalize("~/.bin/rubyfmt"),
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
    },
    ruby_lsp = {
      enable = true,
      use_bundler = true,
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
    },
  })
end

return M
