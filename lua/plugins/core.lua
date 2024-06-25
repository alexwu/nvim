return {
  {
    "willothy/flatten.nvim",
    config = true,
    opts = function()
      ---@type Terminal?
      local saved_terminal

      return {
        window = {
          open = "alternate",
        },
        callbacks = {
          should_block = function(argv)
            return vim.tbl_contains(argv, "-b")
          end,
          pre_open = function()
            local term = require("toggleterm.terminal")
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and saved_terminal then
              saved_terminal:close()
            else
              vim.api.nvim_set_current_win(winnr)

              require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
            end

            if ft == "gitcommit" or ft == "gitrebase" then
              vim.api.nvim_create_autocmd("BufWritePost", {
                buffer = bufnr,
                once = true,
                callback = vim.schedule_wrap(function()
                  vim.api.nvim_buf_delete(bufnr, {})
                end),
              })
            end
          end,
          block_end = function()
            vim.schedule(function()
              if saved_terminal then
                saved_terminal:open()
                saved_terminal = nil
              end
            end)
          end,
        },
      }
    end,
    lazy = false,
    priority = 1001,
  },
  { "tpope/vim-repeat", lazy = false },
  {
    "nvim-lua/plenary.nvim",
    config = function()
      require("plenary.filetype").add_file("extras")
      require("globals")
      require("bombeelu.nvim")
      require("bombeelu.autocmd")
      require("bombeelu.commands")
      require("mappings")

      if not vim.g.vscode then
        require("bombeelu.visual-surround").setup()
      end
    end,
    lazy = false,
    priority = 1001,
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
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" },
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
    "echasnovski/mini.surround",
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
}
