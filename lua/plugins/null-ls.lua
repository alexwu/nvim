return {
  "nvimtools/none-ls.nvim",
  event = "VeryLazy",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "ckolkey/ts-node-action" },
  config = function()
    require("plugins.lsp.null-ls").setup()
  end,
}
