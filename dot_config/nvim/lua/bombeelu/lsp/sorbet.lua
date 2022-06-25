local M = {}

function M.setup(opts)
  require("ruby").setup({
    sorbet = {
      experimental = true,
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
    },
  })

  -- opts.capabilities.sorbetShowSymbolProvider = tru
  --
  -- lspconfig.sorbet.setup({
  --   on_attach = opts.on_attach,
  --   capabilities = opts.capabilities,
  --   filetypes = { "ruby" },
  --   cmd = {
  --     "bundle",
  --     "exec",
  --     "srb",
  --     "tc",
  --     "--lsp",
  --     -- "--enable-all-beta-lsp-features",
  --     "--enable-all-experimental-lsp-features",
  --   },
  --   root_dir = root_pattern("sorbet"),
  --   commands = {
  --     SorbetFormat = {
  --       function()
  --         sorbet.format()
  --       end,
  --       description = "Format using sorbet",
  --     },
  --   },
  -- })
end

function M.format()
  vim.lsp.buf.format({
    name = "sorbet",
    async = true,
  })
end

return M
