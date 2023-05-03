return {
  "jose-elias-alvarez/null-ls.nvim",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "ckolkey/ts-node-action" },
  config = function()
    require("plugins.lsp.null-ls").setup()
  end,
}
