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
      -- {
      --   "w",
      --   mode = { "n", "x" },
      --   function()
      --     require("flash").jump({
      --       search = {
      --         multi_window = false,
      --         -- Use a custom function for the search mode to match word beginnings
      --         mode = function(str)
      --           return "\\<" .. str
      --         end,
      --       },
      --       -- Additional option to restrict to current line
      --       matcher = function(win)
      --         -- Get cursor position
      --         local cursor = vim.api.nvim_win_get_cursor(0)
      --         local current_line = cursor[1]
      --
      --         -- Only create matches on the current line
      --         local matches = {}
      --         local line_text = vim.api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
      --
      --         -- Find all beginnings of words in current line
      --         for word_start in string.gmatch(line_text, "%f[%a%d_]%w+") do
      --           local col = string.find(line_text, word_start)
      --           if col then
      --             -- Create a match at the beginning of the word
      --             table.insert(matches, {
      --               win = win,
      --               pos = { current_line, col - 1 }, -- 1,0-indexed position
      --               end_pos = { current_line, col - 1 + #word_start - 1 },
      --             })
      --           end
      --         end
      --
      --         return matches
      --       end,
      --     })
      --   end,
      --   desc = "Jump forward",
      -- },
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
      -- {
      --   "<leader>sd",
      --   function()
      --     require("flash").jump({
      --       matcher = function(win)
      --         ---@param diag vim.Diagnostic
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
