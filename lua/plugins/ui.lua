return {
  {
    "lewis6991/satellite.nvim",
    event = { "VeryLazy" },
    dependencies = { "gitsigns.nvim" },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("satellite").setup({
        current_only = true,
        excluded_filetypes = { "TelescopePrompt", "TelescopeResults" },
      })
    end,
  },

  { "nvchad/volt", lazy = true },
  {
    "nvchad/minty",
    cmd = { "Shades", "Huefy" },
  },
  {
    "nvchad/menu",
    enabled = false,
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
              rtxt = "<leader>ca",
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
              rtxt = "<leader>hs",
            },
            {
              name = "Reset Hunk",
              cmd = "Gitsigns reset_hunk",
              rtxt = "<leader>hr",
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
        enable = function(buf, win, _)
          if
            not vim.api.nvim_buf_is_valid(buf)
            or not vim.api.nvim_win_is_valid(win)
            or vim.fn.win_gettype(win) ~= ""
            or vim.wo[win].winbar ~= ""
            or vim.bo[buf].ft == "help"
          then
            return false
          end

          local stat = vim.uv.fs_stat(vim.api.nvim_buf_get_name(buf))
          if stat and stat.size > 1024 * 1024 then
            return false
          end

          local ft = vim.bo[buf].ft
          return ft == "markdown"
            or ft == "oil"
            or ft == "fugitive"
            or ft == "codecompanion"
            or pcall(vim.treesitter.get_parser, buf)
            or not vim.tbl_isempty(vim.lsp.get_clients({
              bufnr = buf,
              method = "textDocument/documentSymbol",
            }))
        end,
      },
      sources = {
        path = {
          relative_to = function(buf, win)
            -- Show full path in oil or fugitive buffers
            local bufname = vim.api.nvim_buf_get_name(buf)
            if vim.startswith(bufname, "oil://") or vim.startswith(bufname, "fugitive://") then
              local root = bufname:gsub("^%S+://", "", 1)
              while root and root ~= vim.fs.dirname(root) do
                root = vim.fs.dirname(root)
              end
              return root
            end

            local ok, cwd = pcall(vim.fn.getcwd, win)
            return ok and cwd or vim.fn.getcwd()
          end,
        },
      },
    },
  },
  {
    "rachartier/tiny-glimmer.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "bassamsdata/namu.nvim",
    event = "VeryLazy",
    config = function()
      require("namu").setup({
        -- Enable the modules you want
        namu_symbols = {
          enable = true,
          options = {}, -- here you can configure namu
        },
        -- Optional: Enable other modules if needed
        ui_select = { enable = false }, -- vim.ui.select() wrapper
        colorscheme = {
          enable = false,
          options = {
            -- NOTE: if you activate persist, then please remove any vim.cmd("colorscheme ...") in your config, no needed anymore
            persist = true, -- very efficient mechanism to Remember selected colorscheme
            write_shada = false, -- If you open multiple nvim instances, then probably you need to enable this
          },
        },
      })
      -- === Suggested Keymaps: ===
      set("n", { "<leader>ss", "gO" }, ":Namu symbols<cr>", {
        desc = "Jump to LSP symbol",
        silent = true,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "modern",
      -- preset = "helix",
      ---@type wk.Spec
      spec = {
        {
          mode = { "n", "v" },
          { "[", group = "prev" },
          { "]", group = "next" },
        },
        {
          mode = { "n" },
          { "<Space>", group = "leader" },
        },
      },

      ---@type number | fun(ctx: { keys: string, mode: string, plugin?: string }):number
      delay = function(ctx)
        return ctx.plugin and 0 or 200
      end,

      triggers = {
        { "<auto>", mode = "nixsotc" },
        -- { "s", mode = { "n", "v" } },
        { "<leader>", mode = { "n", "v" } },
        { "<space>", mode = { "n" } },
      },
      icons = {
        rules = false,
      },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
    },
    keys = {
      {
        "g?",
        function()
          require("which-key").show({ global = true })
        end,
        desc = "Keymaps (which-key)",
      },
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },

  -- { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
}
