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
      { "alexwu/bu", url = "git@github.com:alexwu/bu.git" },
    },
  },
  {
    "alexwu/nucleo",
    dependencies = { "runiq/neovim-throttle-debounce" },
    dev = true,
    config = true,
    opts = {},
    keys = {
      {
        "<leader>f",
        function()
          require("nucleo").find()
        end,
        desc = "Fuzzy find file",
      },
    },
  },
}
