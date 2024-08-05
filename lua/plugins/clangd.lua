return {
  {
    "p00f/clangd_extensions.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "aznhe21/actions-preview.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "c", "cpp" },
    config = function()
      require("bombeelu.lsp").clangd.setup()
    end,
  },
}
