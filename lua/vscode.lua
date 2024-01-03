return {
  { "tpope/vim-repeat", lazy = false },
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    opts = {
      skipInsignificantPunctuation = true,
    },
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-w",
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-e",
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-b",
      },
      {
        "ge",
        "<cmd>lua require('spider').motion('ge')<CR>",
        mode = { "n", "o", "x" },
        desc = "Spider-ge",
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    enabled = true,
    ---@type Flash.Config
    opts = {
      search = {
        multi_window = false,
        forwards = false,
      },
      jump = {
        autojump = true,
      },
      modes = {
        search = {
          enabled = false,
        },
        char = {
          enabled = true,
          search = { wrap = false },
          highlight = { backdrop = false },
          jump = { register = false },
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({ search = { forward = true, wrap = false, multi_window = false } })
        end,
        desc = "Jump forward",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump({
            search = { forward = false, wrap = false, multi_window = false },
          })
        end,
        desc = "Jump backward",
      },
      {
        "gsd",
        function()
          require("flash").jump({
            matcher = function(win)
              ---@param diag Diagnostic
              return vim.tbl_map(function(diag)
                return {
                  pos = { diag.lnum + 1, diag.col },
                  end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
                }
              end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
            end,
          })
        end,
        desc = "Jump to diagnostic",
      },
    },
  },
  {
    "nvim-lua/plenary.nvim",
    dependencies = {
      { "alexwu/bu", url = "git@github.com:alexwu/bu.git" },
    },
    config = function()
      -- require("plenary.filetype").add_file("extras")
      require("globals")
      -- require("bombeelu.nvim")
      -- require("bombeelu.autocmd")
      -- require("bombeelu.commands")
      -- require("mappings")

      require("bombeelu.vscode.mappings")
    end,
    lazy = false,
    priority = 1001,
  },
  {
    "alexwu/bu",
    dev = true,
    branch = "dev",
    url = "git@github.com:alexwu/bu.git",
    lazy = false,
  },
  {
    "echasnovski/mini.surround",
    keys = {
      { "ys", desc = "Add surrounding", mode = { "n", "v" } },
      { "ds", desc = "Delete surrounding" },
      { "cs", desc = "Replace surrounding" },
      { "gzf", desc = "Find right surrounding" },
      { "gzF", desc = "Find left surrounding" },
      { "gzh", desc = "Highlight surrounding" },
      { "gzn", desc = "Update `MiniSurround.config.n_lines`" },
    },
    opts = {
      mappings = {
        add = "ys",
        delete = "ds",
        find = "gzf",
        find_left = "gzF",
        highlight = "gzh",
        replace = "cs",
        update_n_lines = "gzn",
      },
      search_method = "cover_or_next",
    },
  },
  {
    "mrjones2014/legendary.nvim",
    dependencies = { "kkharji/sqlite.lua" },
    config = function()
      require("bombeelu.legendary").setup()
      require("bombeelu.scratch").setup()
    end,
    lazy = false,
  },
}
