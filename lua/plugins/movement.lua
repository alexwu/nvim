return {
  {
    "chrisgrieser/nvim-spider",
    event = "VeryLazy",
    opts = {
      skipInsignificantPunctuation = false,
    },
    config = true,
    keys = {
      {
        "w",
        "<cmd>lua require('spider').motion('w')<CR>",
        desc = "Spider-w",
        mode = { "n", "o", "x" },
      },
      {
        "e",
        "<cmd>lua require('spider').motion('e')<CR>",
        desc = "Spider-e",
        mode = { "n", "o", "x" },
      },
      {
        "b",
        "<cmd>lua require('spider').motion('b')<CR>",
        desc = "Spider-b",
        mode = { "n", "o", "x" },
      },
    },
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
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
          multi_line = false,
          jump = { register = false },
        },
      },
    },
    keys = {
      { "s", desc = "+flash" },
      -- {
      --   "s",
      --   function()
      --     require("which-key").show({ keys = "s" })
      --   end,
      --   desc = "+flash",
      -- },
      {
        "ss",
        mode = { "n", "x" },
        function()
          require("flash").jump({ search = { forward = true, wrap = false, multi_window = false } })
        end,
        desc = "Jump forward",
      },
      {
        "S",
        mode = { "n", "x" },
        function()
          require("flash").jump({
            search = { forward = false, wrap = false, multi_window = false },
          })
        end,
        desc = "Jump backward",
      },
      {
        "sS",
        mode = { "n", "x" },
        function()
          require("flash").jump({
            search = { forward = false, wrap = false, multi_window = false },
          })
        end,
        desc = "Jump backward",
      },
      {
        "st",
        mode = { "n", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Jump to Treesitter node",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      -- {
      --   "gsd",
      --   function()
      --     require("flash").jump({
      --       matcher = function(win)
      --         ---@param diag Diagnostic
      --         return vim.tbl_map(function(diag)
      --           return {
      --             pos = { diag.lnum + 1, diag.col },
      --             end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
      --           }
      --         end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
      --       end,
      --     })
      --   end,
      --   desc = "Jump to diagnostic",
      -- },
    },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
    },
    keys = {
      {
        "sw",
        function()
          require("hop").hint_camel_case({ direction = 2 })
        end,
        desc = "Hop camel case",
      },
    },
  },
}
