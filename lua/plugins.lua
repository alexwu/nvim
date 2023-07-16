vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")

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
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        keymaps = {
          visual = "Z",
          visual_line = "gZ",
        },
      })
    end,
  },
  {
    "Bekaboo/dropbar.nvim",
    enabled = vim.fn.has("nvim-0.10.0") == 1,
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
    "mhartington/formatter.nvim",
    event = "VeryLazy",
    config = function()
      require("bombeelu.format")
    end,
  },
  {
    "numToStr/FTerm.nvim",
    event = "VeryLazy",
    config = function()
      require("FTerm").setup({
        border = "rounded",
      })

      local commands = require("legendary").commands

      commands({
        { ":TermOpen", require("FTerm").open, description = "Open terminal", opts = { bang = true } },
        { ":TermClose", require("FTerm").close, description = "Close terminal", opts = { bang = true } },
        { ":TermExit", require("FTerm").exit, description = "Exit terminal", opts = { bang = true } },
        { ":TermToggle", require("FTerm").toggle, description = "Toggle terminal", opts = { bang = true } },
      })

      vim.api.nvim_create_user_command("YarnTest", function()
        require("FTerm").run({ "yarn", "test" })
      end, { bang = true })

      key.map({ [[<C-\>]], [[<C-`>]] }, require("FTerm").toggle, { desc = "Toggle terminal", modes = { "n" } })

      vim.keymap.set("t", [[<C-\>]], require("FTerm").toggle, { desc = "Toggle terminal" })
      vim.keymap.set("t", [[<C-`>]], require("FTerm").toggle, { desc = "Toggle terminal" })
    end,
  },
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "haydenmeade/neotest-jest",
      "olimorris/neotest-rspec",
      "antoinemadec/FixCursorHold.nvim",
    },
    config = function()
      require("bombeelu.neotest").setup()
    end,
    keys = {
      {
        "<leader>tt",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File",
      },
      {
        "<leader>tT",
        function()
          require("neotest").run.run(vim.loop.cwd())
        end,
        desc = "Run All Test Files",
      },
      {
        "<leader>tr",
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
      layout = {
        height = { min = 4, max = 25 },
        width = { min = 20, max = 50 },
        spacing = 3,
        align = "center",
      },
      window = {
        border = "single",
      },
    },
  },
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    enabled = true,
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
        "Trouble",
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
      end, { expr = true })
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
    event = "VeryLazy",
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
  --   "otavioschwanck/ruby-toolkit.nvim",
  --   ft = { "ruby" },
  --   dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
  --   keys = {
  --     {
  --       "<leader>mv",
  --       "<cmd>lua require('ruby-toolkit').extract_variable()<CR>",
  --       desc = "Extract Variable",
  --       mode = { "v" },
  --     },
  --     {
  --       "<leader>mf",
  --       "<cmd>lua require('ruby-toolkit').extract_to_function()<CR>",
  --       desc = "Extract To Function",
  --       mode = { "v" },
  --     },
  --     {
  --       "<leader>mf",
  --       "<cmd>lua require('ruby-toolkit').create_function_from_text()<CR>",
  --       desc = "Create Function from item on cursor",
  --     },
  --   },
  -- },

  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      require("mini.bracketed").setup()
      require("mini.splitjoin").setup()
      require("mini.colors").setup()
      -- require("mini.base16").setup({
      --   palette = {
      --     base00 = "#282a36",
      --     base01 = "#34353e",
      --     base02 = "#43454f",
      --     base03 = "#78787e",
      --     base04 = "#a5a5a9",
      --     base05 = "#e2e4e5",
      --     base06 = "#eff0eb",
      --     base07 = "#f1f1f0",
      --     base08 = "#ff5c57",
      --     base09 = "#ff9f43",
      --     base0A = "#f3f99d",
      --     base0B = "#5af78e",
      --     base0C = "#9aedfe",
      --     base0D = "#57c7ff",
      --     base0E = "#ff6ac1",
      --     base0F = "#b2643c",
      --   },
      -- })
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
    enabled = vim.fn.has("nvim-0.10.0") == 1,
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
    event = "VimEnter",
    opts = function() end,
    config = function()
      local dash = require("alpha.themes.dashboard")

      dash.section.buttons.val = {
        dash.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dash.button("n", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dash.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dash.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
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
      require("other-nvim").setup({
        mappings = {
          -- builtin mappings
          "livewire",
          "angular",
          "laravel",
          "rails",
          "golang",
          -- custom mapping
          {
            pattern = "app/javascript/(.*)/.*.ts$",
            target = "app/javascript/(.*)/.*.test.ts$",
            -- transformer = "lowercase",
          },
        },
        transformers = {
          lowercase = function(inputString)
            return inputString:lower()
          end,
        },
        style = {
          border = "rounded",
          seperator = "|",
          width = 0.7,
          minHeight = 2,
        },
      })
    end,
  },
  {
    "abecodes/tabout.nvim",
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
}

--     use({
--       "andrewferrier/textobj-diagnostic.nvim",
--       config = function()
--         if not vim.g.vscode then
--           require("textobj-diagnostic").setup()
--         end
--       end,
--     })
--
--       use({
--         "nanotee/sqls.nvim",
--         cond = function()
--           return not vim.g.vscode
--         end,
--       })
--
--
--     use({
--       "gennaro-tedesco/nvim-jqx",
--       ft = { "json" },
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     --       use({
--     --         "~/Projects/neovim/spectacle.nvim",
--     --         dependencies = {
--     --           "nvim-lua/plenary.nvim",
--     --           "nvim-telescope/telescope.nvim",
--     --           "MunifTanjim/nui.nvim",
--     --         },
--     --         config = function()
--     --           require("spectacle").setup({
--     --             runners = {},
--     --             ft = {
--     --               javascript = { "jest" },
--     --               javascriptreact = { "jest" },
--     --               lua = { "vusted" },
--     --               typescript = { "jest" },
--     --               typescriptreact = { "jest" },
--     --               ruby = { "rspec" },
--     --             },
--     --           })
--
--     --           require("telescope").load_extension("spectacle")
--     --         end,
--     --         disable = true,
--     --       })
--     use({
--       "andrewferrier/debugprint.nvim",
--       config = function()
--         require("debugprint").setup()
--       end,
--       disable = true,
--     })
--
--     use({
--       "IndianBoy42/tree-sitter-just",
--       config = function()
--         require("tree-sitter-just").setup()
--       end,
--       disable = true,
--     })
