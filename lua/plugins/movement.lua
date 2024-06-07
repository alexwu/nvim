return {
  {
    "backdround/neowords.nvim",
    event = "VeryLazy",
    keys = {
      {
        "w",
        function()
          local neowords = require("neowords")
          local p = neowords.pattern_presets

          local subword_hops =
            neowords.get_word_hops(p.snake_case, p.camel_case, p.upper_case, p.number, p.hex_color, "\\v\\.+", "\\v,+")
          subword_hops.forward_start()
        end,
        mode = { "n", "o", "x" },
        desc = "",
      },
      {
        "e",
        function()
          local neowords = require("neowords")
          local p = neowords.pattern_presets

          local subword_hops =
            neowords.get_word_hops(p.snake_case, p.camel_case, p.upper_case, p.number, p.hex_color, "\\v\\.+", "\\v,+")
          subword_hops.forward_end()
        end,
        mode = { "n", "o", "x" },
        desc = "",
      },
      {
        "b",
        function()
          local neowords = require("neowords")
          local p = neowords.pattern_presets

          local subword_hops =
            neowords.get_word_hops(p.snake_case, p.camel_case, p.upper_case, p.number, p.hex_color, "\\v\\.+", "\\v,+")
          subword_hops.backward_start()
        end,
        mode = { "n", "o", "x" },
        desc = "",
      },
      {
        "ge",
        function()
          local neowords = require("neowords")
          local p = neowords.pattern_presets

          local subword_hops =
            neowords.get_word_hops(p.snake_case, p.camel_case, p.upper_case, p.number, p.hex_color, "\\v\\.+", "\\v,+")
          subword_hops.backward_end()
        end,
        mode = { "n", "o", "x" },
        desc = "",
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
        "gst",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Jump to Treesitter node",
      },
      -- {
      --   "<CR>",
      --   mode = { "n", "x" },
      --   function()
      --     require("flash").treesitter()
      --   end,
      --   desc = "Jump to Treesitter node",
      -- },
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
}
