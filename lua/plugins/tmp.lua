return {
  {
    "alexwu/sorbet-tools.nvim",
    event = "VeryLazy",
    enabled = function()
      return not vim.g.vscode
    end,
    dev = true,
    opts = {
      use_bundler = true,
    },
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      { "alexwu/bu", url = "git@github.com:alexwu/bu.git" },
    },
  },
  {
    "alexwu/nucleo.nvim",
    event = "VeryLazy",
    -- dependencies = { "runiq/neovim-throttle-debounce" },
    url = "git@github.com:alexwu/nucleo.nvim.git",
    dev = true,
    config = true,
    opts = {
      override_vim_select = false,
    },
    keys = {
      {
        "<leader>ff",
        function()
          require("nucleo.sources").find_files()
        end,
        desc = "Find files",
      },
      {
        "<D-p>",
        function()
          require("nucleo.sources").find_files()
        end,
        desc = "Find files",
      },
      {
        "<leader>fF",
        function()
          require("nucleo.sources").find_files({ git_ignore = false, ignore = false })
        end,
        desc = "Find files (no git_ignore)",
      },
      -- {
      --   "<leader>gs",
      --   function()
      --     require("nucleo.sources").git_status()
      --   end,
      --   desc = "Find files by git status",
      -- },
      -- {
      --   "<leader>gh",
      --   function()
      --     require("nucleo.sources").git_hunks()
      --   end,
      --   desc = "Find git hunks",
      -- },
      {
        "<leader>fd",
        function()
          require("nucleo.sources").diagnostics({ scope = "document" })
        end,
        desc = "Find document diagnostics",
      },
      {
        "<leader>fD",
        function()
          require("nucleo.sources").diagnostics({ scope = "workspace" })
        end,
        desc = "Find workspace diagnostics",
      },
    },
  },

  {
    "alexwu/whisper.nvim",
    dev = true,
    opts = {
      model = "~/Code/neovim/plugins/whisper.nvim/models/ggml-large-v3.bin",
      mode = "vad",
    },
  },
}
