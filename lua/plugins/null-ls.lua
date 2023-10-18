return {
  "nvimtools/none-ls.nvim",
  enabled = false,
  event = "VeryLazy",
  dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig", "ckolkey/ts-node-action" },
  config = function()
    require("plugins.lsp.null-ls").setup()
  end,
}
