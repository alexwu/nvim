return {
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
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").jump({
            search = { forward = false, wrap = false, multi_window = false },
          })
        end,
      },
    },
  },
}
