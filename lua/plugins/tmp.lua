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
          require("nucleo.sources").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>F",
        function()
          require("nucleo.sources").find_files({ git_ignore = false, ignore = false })
        end,
        desc = "Find files (no git_ignore)",
      },
      {
        "<leader>gs",
        function()
          require("nucleo.sources").git_status()
        end,
        desc = "Find files by git status",
      },
      {
        "<leader>d",
        function()
          require("nucleo.sources").diagnostics({ scope = "document" })
        end,
        desc = "Find document diagnostics",
      },
      {
        "<leader>D",
        function()
          require("nucleo.sources").diagnostics({ scope = "workspace" })
        end,
        desc = "Find workspace diagnostics",
      },
    },
  },
}
