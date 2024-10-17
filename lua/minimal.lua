return {
  {
    "nvim-lua/plenary.nvim",
    config = function()
      require("plenary.filetype").add_file("extras")
      require("globals")
      require("bombeelu.nvim")
      require("bombeelu.autocmd")
      require("bombeelu.commands")
      require("mappings")

      require("bombeelu.visual-surround").setup()
    end,
    lazy = false,
    priority = 1001,
  },
  {
    "echasnovski/mini.surround",
    cond = true,
    event = "VeryLazy",
    keys = {
      { "ys", desc = "Add surrounding", mode = { "n", "v" } },
      { "ds", desc = "Delete surrounding" },
      { "cs", desc = "Replace surrounding" },
    },
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "",
        find_left = "",
        highlight = "",
        replace = "cs",
        update_n_lines = "",
      },
      search_method = "cover_or_next",
    },
  },
  {
    "lewis6991/fileline.nvim",
    lazy = false,
  },
  {
    "alexwu/nvim-snazzy",
    dependencies = { "rktjmp/lush.nvim" },
    dev = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("snazzy")
    end,
  },
  {
    "folke/ts-comments.nvim",
    opts = {},
    event = "VeryLazy",
  },
  {
    "alexwu/bu",
    dev = true,
    build = "just release",
    url = "git@github.com:alexwu/bu.git",
    config = function()
      local L = require("legendary")
      local bu = require("bu")
      L.command({
        ":Cycle",
        function()
          local s = vim.fn.expand("<cword>")
          vim.print(vim.fn.getpos([[<cword>]]))

          vim.print(bu.cycle_case_forward(s))
        end,
        description = "Cycle string cases",
      })
    end,
  },
  {
    "stevearc/oil.nvim",
    lazy = false,
    opts = {
      delete_to_trash = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = false,
        ["<C-l>"] = false,
        ["<Leader>p"] = {
          desc = "Show image preview",
          callback = function()
            require("image_preview").PreviewImageOil()
          end,
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "adelarsq/image_preview.nvim",
    },
    config = true,
    keys = {
      {
        "-",
        [[<CMD>Oil<CR>]],
        desc = "Go up a directory",
      },
    },
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {},
  },

  { import = "plugins.treesitter" },
  { import = "plugins.legendary" },
  { import = "plugins.dial" },
  { import = "plugins.format" },
  { import = "plugins.tmp" },
  { import = "plugins.telescope" },
  { import = "plugins.tasks" },
  { import = "plugins.movement" },
  { import = "plugins.lsp.init" },
  { import = "plugins.hover" },
  { import = "plugins.statusline.init" },
  {
    "alexwu/ruby-lsp.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    dev = true,
    opts = function()
      return {
        capabilities = require("plugins.lsp.defaults").capabilities,
        on_attach = require("plugins.lsp.defaults").on_attach,
      }
    end,
    config = true,
    cond = function()
      return not vim.g.vscode
    end,
  },
}
