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
            -- Note that argv contains all the parts of the CLI command, including
            -- Neovim's path, commands, options and files.
            -- See: :help v:argv

            -- In this case, we would block if we find the `-b` flag
            -- This allows you to use `nvim -b file1` instead of
            -- `nvim --cmd 'let g:flatten_wait=1' file1`
            return vim.tbl_contains(argv, "-b")

            -- Alternatively, we can block if we find the diff-mode option
            -- return vim.tbl_contains(argv, "-d")
          end,
          pre_open = function()
            local term = require("toggleterm.terminal")
            local termid = term.get_focused_id()
            saved_terminal = term.get(termid)
          end,
          post_open = function(bufnr, winnr, ft, is_blocking)
            if is_blocking and saved_terminal then
              -- Hide the terminal while it's blocking
              saved_terminal:close()
            else
              -- If it's a normal file, just switch to its window
              vim.api.nvim_set_current_win(winnr)

              -- If we're in a different wezterm pane/tab, switch to the current one
              -- Requires willothy/wezterm.nvim
              require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")))
            end

            -- If the file is a git commit, create one-shot autocmd to delete its buffer on write
            -- If you just want the toggleable terminal integration, ignore this bit
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
            -- After blocking ends (for a git commit, etc), reopen the terminal
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
        -- require("bombeelu.pin").setup()
        require("bombeelu.visual-surround").setup()
        -- require("bombeelu.refactoring").setup()
        -- require("bombeelu.just").setup()
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
}
