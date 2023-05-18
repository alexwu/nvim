local defaults = require("plugins.lsp.defaults")
local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern
local M = {}

-- M.format = require("ruby").format

function M.setup(opts)
  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)
  local capabilities = vim.F.if_nil(o.capabilities, defaults.capabilities)

  -- local cmd = {}
  -- local bundler_cmd = { "bundle", "exec" }
  -- local base_cmd = {
  --   "srb",
  --   "tc",
  --   "--lsp",
  -- }
  --
  -- table.insert(cmd, bundler_cmd)
  --
  -- table.insert(cmd, base_cmd)
  --
  -- table.insert(cmd, "--enable-all-experimental-lsp-features")
  -- table.insert(cmd, "--rubyfmt-path")
  -- table.insert(cmd, vim.fs.normalize("~/.bin/rubyfmt"))
  --
  -- capabilities.sorbetShowSymbolProvider = true
  --
  -- lspconfig.sorbet.setup({
  --   on_attach = on_attach,
  --   capabilities = capabilities,
  --   filetypes = { "ruby" },
  --   cmd = vim.tbl_flatten(cmd),
  --   root_dir = root_pattern("sorbet", "Gemfile"),
  --   commands = {
  --     -- SorbetFormat = {
  --     --   function()
  --     --     M.format()
  --     --   end,
  --     --   description = "Format using Sorbet",
  --     -- },
  --     -- SorbetShowSymbol = {
  --     --   function()
  --     --     show_symbol()
  --     --   end,
  --     --   description = "Show Symbol using Sorbet",
  --     -- },
  --   },
  -- })

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

function M.format(opts)
  opts = opts or {}
  local async = opts.async or false

  vim.lsp.buf.format({
    name = "sorbet",
    async = async,
  })
end

return M
