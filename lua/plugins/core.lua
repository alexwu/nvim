return {
  {
    "willothy/flatten.nvim",
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

              require("wezterm").switch_pane.id(tonumber(os.getenv("WEZTERM_PANE")) or 0)
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
    cond = true,
    config = function()
      require("plenary.filetype").add_file("extras")
      require("globals")
      require("bombeelu.nvim")
      require("bombeelu.autocmd")
      require("bombeelu.commands")
      require("mappings")

      if not vim.g.vscode then
        require("bombeelu.visual-surround").setup()
      else
        require("bombeelu.vscode.mappings")
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
    lazy = false,
    opts = {
      delete_to_trash = true,
      watch_for_changes = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["<C-s>"] = false,
        ["<C-h>"] = false,
        ["<C-t>"] = false,
        ["<C-l>"] = false,
        ["<Leader>p"] = {
          desc = "Show image preview",
          callback = function()
            require("image_preview").PreviewImageOil()
          end,
        },
      },
    },
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "adelarsq/image_preview.nvim",
    },
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
    cond = true,
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
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type fun():snacks.Config
    opts = function()
      local in_git = Snacks.git.get_root() ~= nil
      return {
        ---@type table<string, snacks.win.Config>
        styles = {
          scratch = {
            width = 0.9,
            height = 0.9,
            bo = { buftype = "", buflisted = false, bufhidden = "hide", swapfile = false },
            minimal = false,
            noautocmd = false,
            -- position = "right",
            zindex = 20,
            wo = { winhighlight = "NormalFloat:Normal" },
            border = "rounded",
            title_pos = "center",
            footer_pos = "center",
          },
        },
        ---@class snacks.bigfile.Config
        bigfile = {
          enabled = true,
          notify = true, -- show notification when big file detected
          size = 1.5 * 1024 * 1024, -- 1.5MB
          -- Enable or disable features when big file detected
          ---@param ctx {buf: number, ft:string}
          setup = function(ctx)
            vim.b.minianimate_disable = true
            vim.schedule(function()
              vim.bo[ctx.buf].syntax = ctx.ft
            end)
          end,
        },
        input = {},
        dim = {},
        notifier = {},
        quickfile = {},
        scratch = {},
        scroll = { enabled = false },
        statuscolumn = {},
        indent = {},
        words = { enabled = false },
        dashboard = {

          preset = {
            -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
            ---@type fun(cmd:string, opts:table)|nil
            pick = nil,
          -- Used by the `keys` section to show keymaps.
          -- Set your curstom keymaps here.
          -- When using a function, the `items` argument are the default keymaps.
          ---@type snacks.dashboard.Item[]|fun(items:snacks.dashboard.Item[]):snacks.dashboard.Item[]?
          -- stylua: ignore
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = [[:lua require("nucleo.sources").find_files()]] },
              { icon = " ", key = "/", desc = "Grep", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Run", action = [[:lua require("overseer").run_template()]] },
              { icon = " ", key = "n", desc = "Notes", action = [[:Notes]] },
              { icon = " ", key = "c", desc = "Config", action = [[:lua require("bombeelu.pickers").config_files()]] },
              { icon = " ", key = "d", desc = "Diff HEAD", action = [[:DiffviewOpen]] },
              { icon = " ", key = "R", desc = "Restore Session", section = "session" },
              { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          sections = {
            { section = "keys", gap = 1, padding = 1 },
            {
              icon = " ",
              desc = "Browse Repo",
              padding = 1,
              key = "b",
              action = function()
                Snacks.gitbrowse()
              end,
              enabled = in_git,
            },
            -- { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, enabled = not in_git },
            function()
              local cmds = {
                {
                  title = "Notifications",
                  cmd = "gh notify -s -a -n5",
                  action = function()
                    vim.ui.open("https://github.com/notifications")
                  end,
                  icon = " ",
                  height = 5,
                  enabled = true,
                },
                {
                  title = "Open Issues",
                  cmd = "gh issue list -L 3",
                  icon = " ",
                  height = 7,
                },
                {
                  icon = " ",
                  title = "Open PRs",
                  cmd = "gh pr list -L 3",
                  height = 7,
                },
                {
                  icon = " ",
                  title = "Git Status",
                  cmd = "hub --no-pager diff --stat -B -M -C",
                  height = 10,
                },
              }
              return vim.tbl_map(function(cmd)
                return vim.tbl_extend("force", {
                  pane = 1,
                  section = "terminal",
                  enabled = in_git,
                  padding = 1,
                  ttl = 5 * 60,
                  indent = 3,
                }, cmd)
              end, cmds)
            end,
            { section = "startup", padding = 1 },
            {
              section = "terminal",
              pane = 2,
              cmd = "pokemon-colorscripts -r --no-title; sleep .1",
              random = 10,
              indent = 13,
              height = 20,
            },
          },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>fn",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<c-`>", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal (bottom)" },
      { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal (floating)" },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>fs", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      }
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          Snacks.toggle.profiler():map("<leader>pp")
          -- Toggle the profiler highlights
          Snacks.toggle.profiler_highlights():map("<leader>ph")

          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>uc")
          Snacks.toggle.inlay_hints():map("<leader>uh")
          Snacks.toggle.indent():map("<leader>ug")
          Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,
  },
}
