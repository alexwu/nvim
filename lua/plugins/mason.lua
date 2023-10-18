return {
  "williamboman/mason.nvim",
  event = "VeryLazy",
  dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup()
  end,
  cond = function()
    return not vim.g.vscode
  end,
}
