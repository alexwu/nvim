return {
  {
    "lewis6991/satellite.nvim",
    event = { "VeryLazy" },
    dependencies = { "gitsigns.nvim" },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("satellite").setup({
        current_only = true,
      })
    end,
  },

  {
    "goolord/alpha-nvim",
    enabled = false,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "danielfalk/smart-open.nvim",
      "stevearc/overseer.nvim",
    },
    event = "VimEnter",
    opts = function() end,
    config = function()
      local dash = require("alpha.themes.dashboard")

      dash.section.buttons.val = {
        -- stylua: ignore
        dash.button("f", "󰈞 " .. " Files", [[:lua require("nucleo.sources").find_files()<CR>]]),
        dash.button("/", " " .. " Grep", [[:Telescope live_grep <CR>]]),
        dash.button("r", " " .. " Tasks", [[:lua require("overseer").run_template()<CR>]]),
        dash.button("t", "󰙨 " .. " Tests", [[:lua require("neotest").summary.open()<CR>]]),
        dash.button("T", " " .. " To-do", [[:TodoTelescope<CR>]]),
        dash.button("n", "󰎞 " .. " Notes", [[:Notes<CR>]]),
        dash.button("c", " " .. " Config", [[:lua require("bombeelu.pickers").config_files() <CR>]]),
        dash.button("l", "󰒲 " .. " Lazy", [[:Lazy<CR>]]),
        dash.button("q", " " .. " Quit", [[:qa<CR>]]),
      }
      for _, button in ipairs(dash.section.buttons.val) do
        button.opts.hl = "AlphaButtons"
        button.opts.hl_shortcut = "AlphaShortcut"
      end
      dash.section.header.opts.hl = "AlphaHeader"
      dash.section.buttons.opts.hl = "AlphaButtons"
      dash.section.footer.opts.hl = "AlphaFooter"
      dash.opts.layout[1].val = 8
      -- close Lazy and re-open when the dashboard is ready
      if vim.o.filetype == "lazy" then
        vim.cmd.close()
        vim.api.nvim_create_autocmd("User", {
          pattern = "AlphaReady",
          callback = function()
            require("lazy").show()
          end,
        })
      end

      require("alpha").setup(dash.opts)
    end,
  },
  { "nvchad/volt", lazy = true },
  {
    "nvchad/minty",
    cmd = { "Shades", "Huefy" },
  },
  {
    "nvchad/menu",
    lazy = true,
    keys = {
      {
        "<RightMouse>",
        function()
          -- TODO: Write a thing that conditionally adds stuff based on mouse position
          -- like gitsigns, neotest, etc

          local defaults = {

            {
              name = "Format Buffer",
              cmd = function()
                local ok, conform = pcall(require, "conform")

                if ok then
                  conform.format({ lsp_fallback = true })
                else
                  vim.lsp.buf.format()
                end
              end,
              rtxt = "<F8>",
            },

            {
              name = "Code Actions",
              cmd = vim.lsp.buf.code_action,
              rtxt = "<leader>a",
            },

            { name = "separator" },

            {
              name = "  Lsp Actions",
              hl = "Exblue",
              items = "lsp",
            },

            { name = "separator" },

            {
              name = "Stage Hunk",
              cmd = "Gitsigns stage_hunk",
              rtxt = "sh",
            },
            {
              name = "Reset Hunk",
              cmd = "Gitsigns reset_hunk",
              rtxt = "rh",
            },

            {
              name = "Stage Buffer",
              cmd = "Gitsigns stage_buffer",
              rtxt = "sb",
            },
            {
              name = "Undo Stage Hunk",
              cmd = "Gitsigns undo_stage_hunk",
              rtxt = "us",
            },
            {
              name = "Reset Buffer",
              cmd = "Gitsigns reset_buffer",
              rtxt = "rb",
            },
            {
              name = "Preview Hunk",
              cmd = "Gitsigns preview_hunk",
              rtxt = "hp",
            },

            { name = "separator" },

            {
              name = "Blame Line",
              cmd = 'lua require"gitsigns".blame_line{full=true}',
              rtxt = "b",
            },
            {
              name = "Toggle Current Line Blame",
              cmd = "Gitsigns toggle_current_line_blame",
              rtxt = "tb",
            },

            { name = "separator" },

            {
              name = "Diff This",
              cmd = "Gitsigns diffthis",
              rtxt = "dt",
            },
            {
              name = "Diff Last Commit",
              cmd = 'lua require"gitsigns".diffthis("~")',
              rtxt = "dc",
            },
            {
              name = "Toggle Deleted",
              cmd = "Gitsigns toggle_deleted",
              rtxt = "td",
            },

            -- {
            --   name = "Edit Config",
            --   cmd = function()
            --     vim.cmd("tabnew")
            --     local conf = vim.fn.stdpath("config")
            --     vim.cmd("tcd " .. conf .. " | e init.lua")
            --   end,
            --   rtxt = "ed",
            -- },

            -- {
            --   name = "Copy Content",
            --   cmd = "%y+",
            --   rtxt = "<C-c>",
            -- },
            --
            -- {
            --   name = "Delete Content",
            --   cmd = "%d",
            --   rtxt = "dc",
            -- },

            -- { name = "separator" },

            -- {
            --   name = "  Open in terminal",
            --   hl = "ExRed",
            --   cmd = function()
            --     local old_buf = require("menu.state").old_data.buf
            --     local old_bufname = vim.api.nvim_buf_get_name(old_buf)
            --     local old_buf_dir = vim.fn.fnamemodify(old_bufname, ":h")
            --
            --     local cmd = "cd " .. old_buf_dir
            --
            --     -- base46_cache var is an indicator of nvui user!
            --     if vim.g.base46_cache then
            --       require("nvchad.term").new({ cmd = cmd, pos = "sp" })
            --     else
            --       vim.cmd("enew")
            --       vim.fn.termopen({ vim.o.shell, "-c", cmd .. " ; " .. vim.o.shell })
            --     end
            --   end,
            -- },
            --
            -- { name = "separator" },

            -- {
            --   name = "  Color Picker",
            --   cmd = function()
            --     require("minty.huefy").open()
            --   end,
            -- },
          }

          -- if config.mouse then
          --   local pos = vim.fn.getmousepos()
          --   win_opts.win = pos.winid
          --   win_opts.col = api.nvim_win_get_width(pos.winid) + 2
          --   win_opts.row = pos.winrow - 2
          -- else
          --   win_opts.win = api.nvim_get_current_win()
          --   win_opts.col = api.nvim_win_get_width(win_opts.win) + 2
          --   win_opts.row = api.nvim_win_get_cursor(win_opts.win)[1] - 1
          -- end
          require("menu").open(defaults, { mouse = true })
        end,
      },
    },
  },
  {
    "Bekaboo/dropbar.nvim",
    opts = {
      bar = {
        -- enable = function(buf, win)
        --   return not vim.api.nvim_win_get_config(win).zindex
        --     and (vim.bo[buf].buftype == "" or vim.bo[buf].buftype == "terminal")
        --     and vim.api.nvim_buf_get_name(buf) ~= ""
        --     and not vim.wo[win].diff
        -- end,
        -- enable = function(buf, win, _)
        --   return vim.api.nvim_buf_is_valid(buf)
        --     and vim.api.nvim_win_is_valid(win)
        --     and vim.wo[win].winbar == ""
        --     and not vim.wo[win].diff
        --     and not vim.bo[buf].buftype == "terminal"
        --     and ((pcall(vim.treesitter.get_parser, buf, vim.bo[buf].ft)) and true or false)
        -- end,
      },
    },
  },
  -- { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
}
