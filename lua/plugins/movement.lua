return {
  {
    "chrisgrieser/nvim-spider",
    cond = true,
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
    cond = true,
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
          jump_labels = true,
          search = { wrap = false },
          highlight = { backdrop = false },
          multi_line = false,
          jump = {
            register = false,
            autojump = true,
          },
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x" },
        function()
          require("flash").jump({ search = { forward = true, wrap = false, multi_window = false } })
        end,
        desc = "Jump forward",
      },
      {
        "<leader>s",
        "",
        desc = "+jump",
        mode = { "n", "x" },
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
        "<leader>S",
        mode = { "n", "x" },
        function()
          require("flash").jump({
            search = { forward = false, wrap = false, multi_window = false },
          })
        end,
        desc = "Jump backward",
      },

      {
        "<leader>st",
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
    },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    opts = {
      -- keys = "etovxqpdygfblzhckisuran",
    },
    keys = {
      {
        "<leader>sw",
        mode = { "n", "x" },
        function()
          require("hop").hint_camel_case({ direction = 2 })
        end,
        desc = "Jump to a word",
      },
      {
        "<leader>sW",
        mode = { "n", "x" },
        function()
          require("hop").hint_camel_case({ direction = 1 })
        end,
        desc = "Jump backward to a word",
      },
    },
  },
}
