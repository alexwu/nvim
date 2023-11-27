return {
  {
    "alexwu/sorbet-tools.nvim",
    event = "VeryLazy",
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
    "alexwu/nucleo.nvim",
    event = "VeryLazy",
    dependencies = { "runiq/neovim-throttle-debounce" },
    url = "git@github.com:alexwu/nucleo.nvim.git",
    dev = true,
    config = true,
    opts = {},
    keys = {
      {
        "<leader>f",
        function()
          require("nucleo").find()
        end,
        desc = "Fuzzy find files",
      },
    },
  },
}
