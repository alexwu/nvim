local api = vim.api

if jit.os == "OSX" then
  vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")
end

return {
  { "tpope/vim-repeat", lazy = false },
  {
    "sheerun/vim-polyglot",
    lazy = false,
    init = function()
      vim.g.polyglot_disabled = { "sensible", "ftdetect" }
    end,
  },
  { "antoinemadec/FixCursorHold.nvim", lazy = false },
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
    "Bekaboo/dropbar.nvim",
    cond = function()
      return vim.fn.has("nvim-0.10.0") == 1
    end,
    config = true,
    opts = {
      general = {
        enable = function(buf, win)
          return not vim.api.nvim_win_get_config(win).zindex
            and vim.bo[buf].buftype == ""
            and vim.api.nvim_buf_get_name(buf) ~= ""
            and not vim.wo[win].diff
        end,
      },
    },
  },
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
      "rouge8/neotest-rust",
      "olimorris/neotest-rspec",
      "antoinemadec/FixCursorHold.nvim",
    },
    config = function()
      require("bombeelu.neotest").setup()
    end,
    keys = {
      {
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>ta",
        function()
          require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tn",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>tt",
        function()
          require("neotest").run.run()
        end,
        desc = "Run Nearest",
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
        desc = "Toggle Summary",
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true, auto_close = true })
        end,
        desc = "Show Output",
      },
      {
        "<leader>tO",
        function()
          require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel",
      },
      {
        "<leader>tS",
        function()
          require("neotest").run.stop()
        end,
        desc = "Stop",
      },
    },
  },
  {
    "alexwu/ruby.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    dev = true,
    config = function()
      require("bombeelu.lsp").sorbet.setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
    ft = { "ruby" },
    enabled = false,
  },
  {
    "ckolkey/ts-node-action",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("ts-node-action").setup({})
      set({ "n" }, "gJ", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("crates").setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "vuki656/package-info.nvim",
    event = { "BufRead package.json" },
    dependencies = "MunifTanjim/nui.nvim",
    config = true,
    opts = {
      colors = {
        up_to_date = "#57c7ff",
        outdated = "#FF9F43",
      },
    },
  },
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    config = function()
      require("plugins.dressing")
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    config = true,
    opts = {
      operators = { gc = "Comments" },
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
      window = {
        border = "rounded",
      },
    },
  },
  {
    "echasnovski/mini.clue",
    enabled = false,
    version = false,
    lazy = false,
    config = function()
      local miniclue = require("mini.clue")
      miniclue.setup({
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },
        window = {
          config = {},
          delay = 200,
        },
        clues = {
          miniclue.gen_clues.g(),
          miniclue.gen_clues.marks(),
          miniclue.gen_clues.registers(),
          miniclue.gen_clues.windows(),
          miniclue.gen_clues.z(),
        },
      })
    end,
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    enabled = false,
    init = function()
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    opts = {
      exit_when_last = true,
      left = {
        -- Neo-tree filesystem always takes half the screen height
        {
          title = "Neo-Tree",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem" and vim.b[buf].neo_tree_position ~= "current"
          end,
          size = { height = 0.5 },
        },
        {
          title = "Neo-Tree Git",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "git_status"
          end,
          pinned = true,
          open = "Neotree position=right git_status",
        },
      },
      bottom = {
        -- "Trouble",
        { ft = "qf", title = "QuickFix" },
      },
    },
  },
  {
    "smjonas/inc-rename.nvim",
    event = "VeryLazy",
    config = function()
      require("inc_rename").setup({})

      vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
      end, { expr = true, desc = "Rename symbol" })
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    event = "VeryLazy",
    dependencies = {
      "neovim/nvim-lspconfig",
      "hrsh7th/nvim-cmp",
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("bombeelu.lsp").rust.setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "andymass/vim-matchup",
    event = "VeryLazy",
    setup = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    cond = function()
      return not vim.g.vscode
    end,
    enabled = true,
  },
  {
    "akinsho/git-conflict.nvim",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("git-conflict").setup({
        disable_diagnostics = true,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
          vim.cmd([[GitConflictListQf]])
          -- engage.conflict_buster()
          -- create_buffer_local_mappings()
        end,
      })
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "ray-x/go.nvim",
    event = { "VeryLazy" },
    dependencies = { "ray-x/guihua.lua" },
    ft = "go",
    config = function()
      require("bombeelu.lsp.go").setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "lewis6991/spaceless.nvim",
    config = function()
      require("spaceless").setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
    event = "InsertEnter",
  },
  {
    "willothy/wezterm.nvim",
    event = "VeryLazy",
    dependencies = { "mrjones2014/legendary.nvim" },
    enabled = true,
    cond = function()
      return vim.fn.executable("wezterm") ~= 0
    end,
    config = function()
      local w = require("wezterm")
      w.setup({})

      require("legendary").commands({
        {
          "Spawn",
          function(opts)
            local fargs = vim.F.if_nil(vim.deepcopy(opts.fargs), { "" })
            -- table.insert(fargs, 1, "wezterm")
            local program = opts.fargs[1]

            vim.print(program)

            table.remove(fargs, 1)
            local args = fargs
            vim.print(args)

            w.spawn(program, { cwd = vim.loop.cwd(), args = args })
          end,
          description = "Spawn a new wezterm process",
          unfinished = true,
          opts = {
            nargs = "*",
            complete = "shellcmd",
          },
        },
        {
          "WezSplit",
          function(opts)
            local fargs = vim.F.if_nil(vim.deepcopy(opts.fargs), { "" })
            -- table.insert(fargs, 1, "wezterm")
            -- local program = opts.fargs[1]

            -- vim.print(program)

            -- table.remove(fargs, 1)
            -- local args = fargs
            -- vim.print(args)

            w.split_pane.vertical({ cwd = vim.loop.cwd(), program = fargs, percent = 25 })
          end,
          description = "Split a new wezterm process",
          unfinished = true,
          opts = {
            nargs = "*",
            complete = "shellcmd",
          },
        },
      })
    end,
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    requires = "nvim-tree/nvim-web-devicons",
    config = true,
  },
  {
    "kevinhwang91/nvim-bqf",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("bqf").setup({
        auto_enable = true,
        auto_resize_height = false,
        preview = {
          should_preview_cb = function(bufnr, _qwinid)
            return bufnr ~= vim.api.nvim_get_current_buf()
          end,
        },
        func_map = {
          drop = "o",
          openc = "O",
          split = "<C-s>",
          tabdrop = "<C-t>",
          tabc = "",
          ptogglemode = "z,",
        },
      })
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "RRethy/vim-illuminate",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("illuminate").configure({
        -- providers: provider used to get references in the buffer, ordered by priority
        providers = {
          "lsp",
          "treesitter",
        },
        delay = 100,
        filetype_overrides = {},
        filetypes_denylist = {
          "neotree",
        },
      })
    end,
  },
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.bracketed").setup({
        diagnostic = { suffix = "d", options = { float = { border = "rounded" } } },
        treesitter = { suffix = "" },
      })
      require("mini.splitjoin").setup()
      require("mini.colors").setup()
    end,
  },
  {
    "echasnovski/mini.ai",
    -- keys = {
    --   { "a", mode = { "x", "o" } },
    --   { "i", mode = { "x", "o" } },
    -- },
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
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)
      -- register all text objects with which-key
      -- if require("lazyvim.util").has("which-key.nvim") then
      ---@type table<string, string|table>
      local i = {
        [" "] = "Whitespace",
        ['"'] = 'Balanced "',
        ["'"] = "Balanced '",
        ["`"] = "Balanced `",
        ["("] = "Balanced (",
        [")"] = "Balanced ) including white-space",
        [">"] = "Balanced > including white-space",
        ["<lt>"] = "Balanced <",
        ["]"] = "Balanced ] including white-space",
        ["["] = "Balanced [",
        ["}"] = "Balanced } including white-space",
        ["{"] = "Balanced {",
        ["?"] = "User Prompt",
        _ = "Underscore",
        a = "Argument",
        b = "Balanced ), ], }",
        c = "Class",
        f = "Function",
        o = "Block, conditional, loop",
        q = "Quote `, \", '",
        t = "Tag",
      }
      local a = vim.deepcopy(i)
      for k, v in pairs(a) do
        a[k] = v:gsub(" including.*", "")
      end

      local ic = vim.deepcopy(i)
      local ac = vim.deepcopy(a)
      for key, name in pairs({ n = "Next", l = "Last" }) do
        i[key] = vim.tbl_extend("force", { name = "Inside " .. name .. " textobject" }, ic)
        a[key] = vim.tbl_extend("force", { name = "Around " .. name .. " textobject" }, ac)
      end
      require("which-key").register({
        mode = { "o", "x" },
        i = i,
        a = a,
      })
      -- end
    end,
  },
  {
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          names = false,
        },
        buftypes = {},
      })
    end,
    cmd = { "ColorizerToggle" },
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    module = "ssr",
    config = function()
      require("ssr").setup({
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      })
      vim.api.nvim_create_user_command("SSR", require("ssr").open, { bang = true })
    end,
    enabled = false,
  },
  {
    "shortcuts/no-neck-pain.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
      require("no-neck-pain").setup({
        width = 300,
        autocmds = {
          enableOnVimEnter = false,
          enableOnTabEnter = false,
        },
      })
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    opts = {},
  },
  {
    "lewis6991/satellite.nvim",
    cond = function()
      return vim.fn.has("nvim-0.10.0") == 1
    end,
    dependencies = { "gitsigns.nvim" },
    config = function()
      require("satellite").setup({
        current_only = true,
      })
    end,
  },
  {
    "johmsalas/text-case.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
      vim.api.nvim_set_keymap("n", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
      vim.api.nvim_set_keymap("v", "ga.", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Telescope" })
    end,
  },

  {
    "Civitasv/cmake-tools.nvim",
    event = "VeryLazy",
    config = true,
  },
  {
    "goolord/alpha-nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "danielfalk/smart-open.nvim",
    },
    event = "VimEnter",
    opts = function() end,
    config = function()
      local dash = require("alpha.themes.dashboard")

      dash.section.buttons.val = {
        dash.button("<space>", " " .. " Recent files", [[:Telescope smart_open cwd_only=true match_algorithm=fzf <CR>]]),
        -- dash.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dash.button("f", " " .. " Find file", [[:lua require("nucleo").find() <CR>]]),
        dash.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dash.button("/", " " .. " Find text", ":Telescope live_grep <CR>"),
        dash.button("r", " " .. " Run task", ":OverseerRun<CR>"),
        -- dash.button("c", " " .. " Config", ":e $MYVIMRC <CR>"),
        -- dashboard.button("s", " " .. " Restore Session", [[:lua require("persistence").load() <cr>]]),
        dash.button("l", "󰒲 " .. " Lazy", ":Lazy<CR>"),
        dash.button("q", " " .. " Quit", ":qa<CR>"),
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

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyVimStarted",
        callback = function()
          local stats = require("lazy").stats()
          local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
          dash.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
          pcall(vim.cmd.AlphaRedraw)
        end,
      })
    end,
  },
  {
    "rgroli/other.nvim",
    event = "VeryLazy",
    config = function()
      local bu = require("bu")
      local mappings = bu.F.flatten({
        "golang",
        require("bombeelu.other.rails"),
        {
          pattern = "/app/javascript/(.*)/(.*).ts$",
          target = "/app/javascript/%1/%2.test.ts",
          context = "source",
        },
        {
          pattern = "/app/javascript/(.*)/(.*).tsx$",
          target = "/app/javascript/%1/%2.test.tsx",
          context = "source",
        },
        {
          pattern = "/app/javascript/(.*)/(.*).test.ts$",
          target = "/app/javascript/%1/%2.ts",
          context = "test",
        },
        {
          pattern = "/app/javascript/(.*)/(.*).test.tsx$",
          target = "/app/javascript/%1/%2.tsx",
          context = "test",
        },
      })

      require("other-nvim").setup({
        mappings = mappings,
        showMissingFiles = true,
        transformers = {
          lowercase = function(inputString)
            return inputString:lower()
          end,
          strip_test = function(inputString)
            return bu.strings.strip_suffix(inputString, ".test")
          end,
        },
        hooks = {
          filePickerBeforeShow = function(files)
            if vim.iter(files):any(function(entry)
              return entry.exists
            end) then
              return vim
                .iter(files)
                :filter(
                  ---@param entry table (filename (string), context (string), exists (boolean))
                  function(entry)
                    return entry.exists
                  end
                )
                :totable()
            end

            return files
          end,
        },
        style = {
          border = "rounded",
          seperator = "|",
          width = 0.7,
          minHeight = 2,
        },
      })

      api.nvim_create_user_command("O", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end

        require("other-nvim").open(fargs)
      end, { nargs = "*" })

      api.nvim_create_user_command("OSplit", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end
        require("other-nvim").openSplit(fargs)
      end, { nargs = "*" })
      api.nvim_create_user_command("OVSplit", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end
        require("other-nvim").openVSplit(fargs)
      end, { nargs = "*" })
      api.nvim_create_user_command("OClear", function(opts)
        local fargs = opts.fargs
        if vim.tbl_isempty(fargs) then
          fargs = nil
        end
        require("other-nvim").clear(fargs)
      end, { nargs = "*" })
    end,
  },
  {
    "abecodes/tabout.nvim",
    enabled = false,
    config = function()
      require("tabout").setup({
        tabouts = {
          { open = "'", close = "'" },
          { open = '"', close = '"' },
          { open = "`", close = "`" },
        },
      })
    end,
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" },
  },
  {
    "TobinPalmer/rayso.nvim",
    cmd = { "Rayso" },
    opts = {
      options = {
        theme = "candy",
      },
    },
  },
  {
    "lewis6991/hover.nvim",
    enabled = false,
    config = function()
      require("hover").setup({
        init = function()
          require("hover.providers.lsp")
          require("hover.providers.gh")
          require("hover.providers.gh_user")
          require("hover.providers.man")
          require("hover.providers.dictionary")
        end,
        preview_opts = {
          border = "rounded",
        },
        preview_window = false,
        title = true,
      })

      vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
      vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
    end,
  },

  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    config = function()
      require("bombeelu.folds").setup()
    end,
    event = "VeryLazy",
  },

  {
    "lewis6991/fileline.nvim",
    lazy = false,
  },
  {
    "stevearc/overseer.nvim",
    config = true,
    opts = {},
    keys = {
      {
        "<leader>o",
        ":OverseerRun<CR>",
        desc = "Run task",
      },
    },
  },
}
