return {
  {
    "willothy/flatten.nvim",
    version = "*",
    opts = function()
      ---@type Terminal?
      local saved_terminal

      return {
        window = {
          open = "alternate",
        },
        hooks = {
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
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      win_options = {
        signcolumn = "yes:2",
      },
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
        desc = "Open parent directory",
      },
    },
  },
  {
    "malewicz1337/oil-git.nvim",
    dependencies = { "stevearc/oil.nvim" },
    opts = {
      --  git_status = {
      -- symbols = {
      --   -- Change type
      --   added = "", -- or "✚"
      --   modified = "", -- or ""
      --   deleted = "✖", -- this can only be used in the git_status source
      --   -- Status type
      --   untracked = "",
      --   ignored = "",
      --   unstaged = "󰄱",
      --   staged = "",
      --   conflict = "",
      -- },

      symbols = {
        file = {
          added = "✚",
          modified = "",
          renamed = "󰁕",
          deleted = "✖",
          copied = "C",
          conflict = "",
          untracked = "",
          ignored = "",
        },
        directory = {
          added = "✚",
          modified = "",
          renamed = "󰁕",
          deleted = "✖",
          copied = "C",
          conflict = "",
          untracked = "",
          ignored = "",
        },
      },
    },
  },
  {
    "A7Lavinraj/fyler.nvim",
    enabled = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = { integrations = { icons = "nvim_web_devicons" } },
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
          zen = {
            width = 250,
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
            -- vim.b.minianimate_disable = true
            -- vim.schedule(function()
            --   vim.bo[ctx.buf].syntax = ctx.ft
            -- end)
          end,
        },
        input = {},
        dim = {},
        notifier = {},
        quickfile = { enabled = false },
        scratch = {},
        scroll = { enabled = false },
        picker = {
          enabled = true,
          win = {
            input = {
              keys = {
                ["<Esc>"] = { "close", mode = { "n", "i" } },
                ["<c-u>"] = { "clear_input", mode = { "i" } },
              },
            },
          },
          actions = {
            clear_input = function(picker)
              picker.input:set("")
            end,
          },
        },
        statuscolumn = {},
        ---@class snacks.indent.Config
        indent = {
          enabled = false,
          only_scope = true,
          only_current = true,
        },
        scope = {
          edge = false,
        },
        words = { enabled = false },
        zen = {
          toggles = {
            dim = false,
            git_signs = true,
            mini_diff_signs = false,
            -- diagnostics = false,
            -- inlay_hints = false,
          },
          show = {
            statusline = true, -- can only be shown when using the global statusline
            tabline = true,
          },
        },
        dashboard = {
          preset = {
            -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
            ---@type fun(cmd:string, opts:table)|nil
            pick = nil,
            -- Used by the `keys` section to show keymaps.
            -- Set your curstom keymaps here.
            -- When using a function, the `items` argument are the default keymaps.
            ---@type snacks.dashboard.Item[]|fun(items:snacks.dashboard.Item[]):snacks.dashboard.Item[]?
            keys = {
              {
                icon = " ",
                key = "f",
                desc = "Find File",
                action = [[:lua require("bombeelu.pickers").files()]],
              },
              { icon = " ", key = "/", desc = "Grep", action = ":Telescope live_grep" },
              { icon = " ", key = "r", desc = "Run", action = [[:lua require("overseer").run_template()]] },
              -- { icon = " ", key = "n", desc = "Notes", action = [[:Notes]] },
              {
                icon = " ",
                key = "c",
                desc = "Config",
                action = [[:lua require("bombeelu.pickers").config_files()]],
              },
              {
                icon = " ",
                key = "d",
                desc = "Diff HEAD",
                action = [[:DiffviewOpen]],

                enabled = in_git,
              },
              { icon = " ", key = "R", desc = "Restore Session", section = "session" },
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
              { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
          },
          sections = {
            { section = "keys", gap = 1, padding = 1 },
            -- { pane = 1, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
            { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1, enabled = not in_git },
            function()
              local cmds = {
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
              enabled = vim.fn.executable("pokemon-colorscripts"),
            },
          },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>z", function() Snacks.zen() end, desc = "Toggle Zen Mode" },
      { "<leader>Z", function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse" },
      { "<leader>gl", function() Snacks.lazygit() end, desc = "Lazygit" },
      { "<c-`>", function() Snacks.terminal.toggle() end, desc = "Toggle Terminal (bottom)" },
      { "<c-/>", function() Snacks.terminal() end, desc = "Toggle Terminal (floating)" },
      { "<c-_>", function() Snacks.terminal() end, desc = "which_key_ignore" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference" },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      -- { "<leader>/", function() Snacks.picker.grep({ }) end, desc = "Live Grep" },
      { "<leader>fs", function() Snacks.scratch.select() end, desc = "Select from scratch buffers" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Find files by Git status" },
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Select from open buffers" },
      { "<leader>f/", function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>fc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>fii", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>fn", function() Snacks.picker.notifications() end, desc = "Notification History" },

      { "<leader>ns", function()
        vim.ui.input({ prompt = "Input scratch buffer file type" }, function(ft)
          if ft then
            Snacks.scratch.open({ ft = ft })
          end
        end)
      end, desc = "New Scratch Buffer" },
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
  {
    "ColinKennedy/mega.cmdparse",
    lazy = true,
    dependencies = { "ColinKennedy/mega.logging" },
    version = "v1.*",
  },
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar" },
    opts = {
      engine = "ripgrep",
    },
  },
  {
    "echasnovski/mini.splitjoin",
    event = "VeryLazy",
    version = false,
    opts = {
      diagnostic = { suffix = "" },
      treesitter = { suffix = "" },
      quickfix = { suffix = "" },
      comment = { suffix = "" },
    },
  },
  {
    "echasnovski/mini.ai",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter-textobjects" },
    opts = function()
      local ai = require("mini.ai")
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
          d = { "%f[%d]%d+" }, -- digits
          e = { -- Word with case
            {
              "%u[%l%d]+%f[^%l%d]",
              "%f[%S][%l%d]+%f[^%l%d]",
              "%f[%P][%l%d]+%f[^%l%d]",
              "^[%l%d]+%f[^%l%d]",
            },
            "^().*()$",
          },
          g = function() -- Whole buffer, similar to `gg` and 'G' motion
            local from = { line = 1, col = 1 }
            local to = {
              line = vim.fn.line("$"),
              col = math.max(vim.fn.getline("$"):len(), 1),
            }
            return { from = from, to = to }
          end,
          u = ai.gen_spec.function_call(), -- u for "Usage"
          U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      local objects = {
        { " ", desc = "whitespace" },
        { '"', desc = '" string' },
        { "'", desc = "' string" },
        { "(", desc = "() block" },
        { ")", desc = "() block with ws" },
        { "<", desc = "<> block" },
        { ">", desc = "<> block with ws" },
        { "?", desc = "user prompt" },
        { "U", desc = "use/call without dot" },
        { "[", desc = "[] block" },
        { "]", desc = "[] block with ws" },
        { "_", desc = "underscore" },
        { "`", desc = "` string" },
        { "a", desc = "argument" },
        { "b", desc = ")]} block" },
        { "c", desc = "class" },
        { "d", desc = "digit(s)" },
        { "e", desc = "CamelCase / snake_case" },
        { "f", desc = "function" },
        { "g", desc = "entire file" },
        { "i", desc = "indent" },
        { "o", desc = "block, conditional, loop" },
        { "q", desc = "quote `\"'" },
        { "t", desc = "tag" },
        { "u", desc = "use/call" },
        { "{", desc = "{} block" },
        { "}", desc = "{} with ws" },
      }

      local ret = { mode = { "o", "x" } }
      ---@type table<string, string>
      local mappings = vim.tbl_extend("force", {}, {
        around = "a",
        inside = "i",
        around_next = "an",
        inside_next = "in",
        around_last = "al",
        inside_last = "il",
      }, opts.mappings or {})
      mappings.goto_left = nil
      mappings.goto_right = nil

      for name, prefix in pairs(mappings) do
        name = name:gsub("^around_", ""):gsub("^inside_", "")
        ret[#ret + 1] = { prefix, group = name }
        for _, obj in ipairs(objects) do
          local desc = obj.desc
          if prefix:sub(1, 1) == "i" then
            desc = desc:gsub(" with ws", "")
          end
          ret[#ret + 1] = { prefix .. obj[1], desc = obj.desc }
        end
      end
      require("which-key").add(ret, { notify = false })
    end,
  },
  { "nmac427/guess-indent.nvim", opts = {} },
}
