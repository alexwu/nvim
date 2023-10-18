return {
  {
    "alexwu/sorbet-tools.nvim",
    enabled = function()
      return not vim.g.vscode
    end,
    dev = true,
    config = true,
    opts = {},
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      { "alexwu/bombeeutils", url = "git@github.com:alexwu/bombeeutils.git" },
    },
  },
}
