vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")
vim.fn.setenv("NEOVIM_PLUGINS_LOCAL", vim.fs.normalize("~/Code/neovim/plugins/"))

return {
  {
    "alexwu/nvim-snazzy",
    dependencies = { "rktjmp/lush.nvim" },
    branch = "lush",
    dev = true,
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme snazzy")
    end,
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
  { "tpope/vim-repeat" },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup({
        enable = true,
        max_lines = 3,
        trim_scope = "outer",
        patterns = {
          default = {
            "class",
            "function",
            "method",
            "for",
            "while",
            "if",
            "switch",
            "case",
          },
        },
        zindex = 41,
      })
    end,
  },
  {
    "kylechui/nvim-surround",
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
    "ggandor/leap.nvim",
    config = function()
      require("bombeelu.leap").setup()
    end,
    dependencies = {
      "ggandor/leap-spooky.nvim",
      "ggandor/flit.nvim",
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "folke/noice.nvim",
    event = "VimEnter",
    config = function()
      require("noice").setup({
        popupmenu = {
          enabled = false,
        },
        notify = { enabled = true },
        lsp = {
          progress = {
            enabled = true,
            -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
            -- See the section on formatting for more details on how to customize.
            --- @type NoiceFormat|string
            format = "lsp_progress",
            --- @type NoiceFormat|string
            format_done = "lsp_progress_done",
            throttle = 1000 / 30, -- frequency to update lsp progress message
            view = "mini",
          },
          documentation = {
            view = "hover",
            ---@type NoiceViewOptions
            opts = {
              lang = "markdown",
              replace = true,
              render = "plain",
              format = { "{message}" },
              win_options = { concealcursor = "n", conceallevel = 3 },
            },
          },
        },
        presets = {
          command_palette = true,
          long_message_to_split = true,
          inc_rename = true,
        },
      })

      require("telescope").load_extension("noice")
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      require("bombeelu.format")
    end,
  },
  {
    "williamboman/mason.nvim",
    dependencies = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "numToStr/FTerm.nvim",
    config = function()
      require("FTerm").setup({
        border = "rounded",
      })
      vim.api.nvim_create_user_command("FTermOpen", require("FTerm").open, { bang = true })
      vim.api.nvim_create_user_command("FTermClose", require("FTerm").close, { bang = true })
      vim.api.nvim_create_user_command("FTermExit", require("FTerm").exit, { bang = true })
      vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
      -- vim.keymap.set("n", [[<C-\>]], require("FTerm").toggle)
      -- vim.keymap.set("t", [[<C-\>]], '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>')
    end,
  },

  --     use({ "lewis6991/impatient.nvim" })
  --
  --
  --     use({
  --       "rcarriga/nvim-notify",
  --       dependencies = { "nvim-telescope/telescope.nvim" },
  --       config = function()
  --         if not vim.g.vscode then
  --           require("plugins.notify")
  --         end
  --       end,
  --     })
  --
  --     use({
  --       "sheerun/vim-polyglot",
  --       setup = function()
  --         vim.g.polyglot_disabled = { "sensible", "ftdetect", "lua", "rust", "typescript", "typescriptreact" }
  --       end,
  --       cond = function()
  --         return not vim.g.vscode
  --       end,
  --       disable = true,
  --     })
  --
  --
  {
    "zbirenbaum/copilot.lua",
    dependencies = { "hrsh7th/nvim-cmp" },
    event = "InsertEnter",
    config = function()
      vim.schedule(function()
        require("copilot").setup()
      end)
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },

  {
    "zbirenbaum/copilot-cmp",
    dependencies = { "hrsh7th/nvim-cmp", "zbirenbaum/copilot.lua" },
    after = "copilot.lua",
    config = function()
      require("copilot_cmp").setup({
        method = "getCompletionsCycling",
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      })
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
}
--
--     use({
--       "saecki/crates.nvim",
--       event = { "BufRead Cargo.toml" },
--       dependencies = { "nvim-lua/plenary.nvim" },
--       config = function()
--         require("crates").setup()
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({ "MunifTanjim/nui.nvim" })
--
--     use({
--       "stevearc/dressing.nvim",
--       config = function()
--         require("plugins.dressing")
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "andrewferrier/textobj-diagnostic.nvim",
--       config = function()
--         if not vim.g.vscode then
--           require("textobj-diagnostic").setup()
--         end
--       end,
--     })
--
--     use({
--       "smjonas/inc-rename.nvim",
--       config = function()
--         require("inc_rename").setup({
--           input_buffer_type = "dressing",
--         })
--
--         vim.keymap.set("n", "<leader>rn", function()
--           return ":IncRename " .. vim.fn.expand("<cword>")
--         end, { expr = true })
--       end,
--     })
--
--     use({
--       "SmiteshP/nvim-navic",
--       dependencies = { "neovim/nvim-lspconfig" },
--       setup = function()
--         vim.g.navic_silence = true
--       end,
--       config = function()
--         require("nvim-navic").setup({
--           highlight = true,
--         })
--       end,
--     })
--
--     use({
--       "nvim-treesitter/playground",
--       cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle", "TSNodeUnderCursor" },
--     })
--
--     use({
--       "windwp/nvim-autopairs",
--       config = function()
--         require("plugins.autopairs")
--       end,
--       dependencies = { "hrsh7th/nvim-cmp" },
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "windwp/nvim-ts-autotag",
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "andymass/vim-matchup",
--       setup = function()
--         vim.g.matchup_matchparen_deferred = 1
--         vim.g.matchup_matchparen_offscreen = { method = "popup" }
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--       disable = true,
--     })
--
--     use({
--       "jose-elias-alvarez/typescript.nvim",
--       ft = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
--       cond = function()
--         return not vim.g.vscode
--       end,
--       config = function()
--         require("bombeelu.lsp").typescript.setup()
--       end,
--     })
--
--     use({
--       "simrat39/rust-tools.nvim",
--       ft = "rust",
--       dependencies = {
--         "neovim/nvim-lspconfig",
--         "hrsh7th/nvim-cmp",
--         "nvim-lua/popup.nvim",
--         "nvim-lua/plenary.nvim",
--         "nvim-telescope/telescope.nvim",
--       },
--       config = function()
--         require("bombeelu.lsp").rust.setup()
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "p00f/clangd_extensions.nvim",
--       ft = { "c", "cpp" },
--       config = function()
--         require("bombeelu.lsp").clangd.setup()
--       end,
--     })
--     -- use({
--     --   "ray-x/go.nvim",
--     --   dependencies = "ray-x/guihua.lua",
--     --   ft = "go",
--     --   config = function()
--     --     require("bombeelu.lsp.go").setup()
--     --   end,
--     --   cond = function()
--     --     return not vim.g.vscode
--     --   end,
--     -- })
--
--     --       use({
--     --         "nanotee/sqls.nvim",
--     --         cond = function()
--     --           return not vim.g.vscode
--     --         end,
--     --       })
--
--     use({
--       "mfussenegger/nvim-dap",
--       dependencies = {
--         "rcarriga/nvim-dap-ui",
--         "theHamsta/nvim-dap-virtual-text",
--         "mxsdev/nvim-dap-vscode-js",
--       },
--       config = function()
--         require("bombeelu.dap").setup()
--       end,
--     })
--
--     use({
--       "microsoft/vscode-js-debug",
--       opt = true,
--       run = "npm install --legacy-peer-deps && npm run compile",
--     })
--
--     use({
--       "gennaro-tedesco/nvim-jqx",
--       ft = { "json" },
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "kevinhwang91/nvim-bqf",
--       config = function()
--         require("bqf").setup({
--           auto_enable = true,
--           auto_resize_height = false,
--           preview = {
--             should_preview_cb = function(bufnr, _qwinid)
--               return bufnr ~= vim.api.nvim_get_current_buf()
--             end,
--           },
--           func_map = {
--             drop = "o",
--             openc = "O",
--             split = "<C-s>",
--             tabdrop = "<C-t>",
--             tabc = "",
--             ptogglemode = "z,",
--           },
--         })
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "kyazdani42/nvim-tree.lua",
--       dependencies = { "kyazdani42/nvim-web-devicons" },
--       config = function()
--         require("plugins.tree")
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--
--     use({
--       "da-moon/telescope-toggleterm.nvim",
--       event = "TermOpen",
--       dependencies = {
--         "akinsho/toggleterm.nvim",
--         "nvim-telescope/telescope.nvim",
--         "nvim-lua/popup.nvim",
--         "nvim-lua/plenary.nvim",
--       },
--       config = function()
--         require("telescope").load_extension("toggleterm")
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "folke/todo-comments.nvim",
--       config = function()
--         require("plugins.todo-comments")
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "NvChad/nvim-colorizer.lua",
--       config = function()
--         require("colorizer").setup({
--           filetypes = { "*" },
--           user_default_options = {
--             names = false, -- "Name" codes like Blue or blue
--           },
--           -- all the sub-options of filetypes apply to buftypes
--           buftypes = {},
--         })
--       end,
--       cmd = { "ColorizerToggle" },
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "lewis6991/gitsigns.nvim",
--       dependencies = { "nvim-lua/plenary.nvim" },
--       config = function()
--         require("plugins.gitsigns")
--       end,
--     })
--
--     use({
--       "akinsho/git-conflict.nvim",
--       config = function()
--         require("git-conflict").setup({
--           disable_diagnostics = true,
--         })
--
--         vim.api.nvim_create_autocmd("User", {
--           pattern = "GitConflictDetected",
--           callback = function()
--             vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
--             vim.cmd([[GitConflictListQf]])
--             -- engage.conflict_buster()
--             -- create_buffer_local_mappings()
--           end,
--         })
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "sindrets/diffview.nvim",
--       config = function()
--         require("plugins.diffview")
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "dsznajder/vscode-es7-javascript-react-snippets",
--       run = "yarn install --frozen-lockfile && yarn compile",
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--
--     use({
--       "lewis6991/spaceless.nvim",
--       config = function()
--         require("spaceless").setup()
--       end,
--       cond = function()
--         return not vim.g.vscode
--       end,
--       event = "InsertEnter",
--       disable = false,
--     })
--
--     use({
--       "tpope/vim-projectionist",
--       dependencies = { "tpope/vim-dispatch" },
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })
--     use({ "tpope/vim-rails", ft = "ruby", disable = true })
--
--     use({
--       "chaoren/vim-wordmotion",
--       config = function()
--         set("n", "w", "<Plug>WordMotion_w", { silent = true })
--       end,
--       disable = true,
--     })
--     use({ "AndrewRadev/splitjoin.vim" })
--
--     use({
--       "beauwilliams/focus.nvim",
--       config = function()
--         if not vim.g.vscode then
--           require("plugins.focus")
--         end
--       end,
--     })
--
--     use({
--       "folke/which-key.nvim",
--       config = function()
--         require("which-key").setup({})
--       end,
--     })
--
--     use({
--       "folke/neodev.nvim",
--       ft = "lua",
--       dependencies = {
--         "neovim/nvim-lspconfig",
--         "hrsh7th/nvim-cmp",
--       },
--       config = function()
--         require("bombeelu.lsp").lua.setup()
--       end,
--       cond = function()
--         return vim.g.vscode
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
--
--     -- use({
--     --   "~/Projects/neovim/telescope-commander.nvim",
--     --   dependencies = {
--     --     "nvim-lua/plenary.nvim",
--     --     "nvim-telescope/telescope.nvim",
--     --   },
--     --   cond = function()
--     --     return vim.g.vscode
--     --   end,
--     -- })
--     --
--
--     use_local("alexwu", "ruby.nvim", {
--       dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
--       config = function()
--         if not vim.g.vscode then
--           require("bombeelu.lsp").sorbet.setup()
--         end
--       end,
--     })
--
--     use({
--       "simrat39/inlay-hints.nvim",
--       config = function()
--         if not vim.g.vscode then
--           require("inlay-hints").setup({
--             renderer = "inlay-hints/render/eol",
--             hints = {
--               parameter = {
--                 show = false,
--                 highlight = "LspInlayHints",
--               },
--               type = {
--                 show = true,
--                 highlight = "LspInlayHints",
--               },
--             },
--             only_current_line = false,
--             eol = {
--               right_align = false,
--               right_align_padding = 7,
--               parameter = {
--                 separator = ", ",
--                 format = function(hints)
--                   return string.format(" <- (%s)", hints)
--                 end,
--               },
--
--               type = {
--                 separator = ", ",
--                 format = function(hints)
--                   return string.format(" => (%s)", hints)
--                 end,
--               },
--             },
--           })
--         end
--       end,
--       disable = true,
--     })
--
--     use({
--       "lvimuser/lsp-inlayhints.nvim",
--       branch = "anticonceal",
--       config = function()
--         require("lsp-inlayhints").setup()
--         vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
--         vim.api.nvim_create_autocmd("LspAttach", {
--           group = "LspAttach_inlayhints",
--           callback = function(args)
--             if not (args.data and args.data.client_id) then
--               return
--             end
--
--             local bufnr = args.buf
--             local client = vim.lsp.get_client_by_id(args.data.client_id)
--             require("lsp-inlayhints").on_attach(client, bufnr)
--           end,
--         })
--       end,
--     })
--
--     use({
--       "mrshmllow/document-color.nvim",
--       config = function()
--         require("document-color").setup({})
--       end,
--     })
--
--     use({
--       "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
--       config = function()
--         require("lsp_lines").setup()
--         vim.diagnostic.config({ virtual_lines = false })
--
--         vim.keymap.set("n", "gL", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
--       end,
--     })
--
--     use({
--       "andrewferrier/debugprint.nvim",
--       config = function()
--         require("debugprint").setup()
--       end,
--       disable = true,
--     })
--
--     use({
--       "kevinhwang91/nvim-ufo",
--       dependencies = "kevinhwang91/promise-async",
--       config = function()
--         require("bombeelu.folds").setup()
--       end,
--       cond = function()
--         return not vim.g.vscode
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
--

--
--     use({
--       "ziontee113/syntax-tree-surfer",
--       config = function()
--         require("bombeelu.syntax-tree-surfer").setup()
--       end,
--     })
--
--     use({
--       "nvim-neotest/neotest",
--       dependencies = {
--         "nvim-lua/plenary.nvim",
--         "nvim-treesitter/nvim-treesitter",
--         "haydenmeade/neotest-jest",
--         "olimorris/neotest-rspec",
--       },
--       config = function()
--         require("bombeelu.neotest").setup()
--       end,
--     })
--
--     use({
--       "zbirenbaum/neodim",
--       event = "LspAttach",
--       config = function()
--         require("neodim").setup({
--           alpha = 0.5,
--           blend_color = "#282a36",
--           update_in_insert = {
--             enable = false,
--             delay = 400,
--           },
--           hide = {
--             virtual_text = true,
--             signs = false,
--             underline = true,
--           },
--         })
--       end,
--     })
--
--     use({
--       "ggandor/leap.nvim",
--       config = function()
--         require("bombeelu.leap").setup()
--       end,
--       dependencies = {
--         "ggandor/leap-spooky.nvim",
--         "ggandor/flit.nvim",
--         "nvim-telescope/telescope.nvim",
--       },
--     })
--
--     use({
--       "lewis6991/satellite.nvim",
--       config = function()
--         if not vim.g.vscode then
--           require("satellite").setup({
--             current_only = true,
--           })
--         end
--       end,
--     })
--
--     use({
--       "nvim-telescope/telescope-dap.nvim",
--       dependencies = { "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap" },
--       config = function()
--         require("telescope").load_extension("dap")
--       end,
--     })
--
--     use({
--       "aarondiel/spread.nvim",
--       after = "nvim-treesitter",
--       config = function()
--         local spread = require("spread")
--         local default_options = { silent = true, noremap = true }
--
--         vim.keymap.set("n", "gS", spread.out, default_options)
--         vim.keymap.set("n", "gJ", spread.combine, default_options)
--       end,
--       disable = true,
--     })
--
--     use({
--       "ibhagwan/fzf-lua",
--       dependencies = { "kyazdani42/nvim-web-devicons" },
--       disable = true,
--     })
--
--     use({ "junegunn/vim-easy-align" })
--
--     use({
--       "folke/noice.nvim",
--       event = "VimEnter",
--       config = function()
--         require("noice").setup({
--           popupmenu = {
--             enabled = false,
--           },
--           routes = {
--             {
--               filter = {
--                 event = "msg_show",
--                 kind = "",
--                 find = "written",
--               },
--               opts = { skip = true },
--             },
--             {
--               filter = {
--                 event = "msg_show",
--                 kind = "search_count",
--               },
--               opts = { skip = true },
--             },
--           },
--           notify = { enabled = true },
--           lsp = {
--             progress = {
--               enabled = true,
--               -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
--               -- See the section on formatting for more details on how to customize.
--               --- @type NoiceFormat|string
--               format = "lsp_progress",
--               --- @type NoiceFormat|string
--               format_done = "lsp_progress_done",
--               throttle = 1000 / 30, -- frequency to update lsp progress message
--               view = "mini",
--             },
--             hover = {
--               enabled = false,
--               view = nil, -- when nil, use defaults from documentation
--               ---@type NoiceViewOptions
--               opts = {}, -- merged with defaults from documentation
--             },
--             signature = {
--               enabled = false,
--               auto_open = true, -- Automatically show signature help when typing a trigger character from the LSP
--               view = nil, -- when nil, use defaults from documentation
--               ---@type NoiceViewOptions
--               opts = {}, -- merged with defaults from documentation
--             },
--             -- defaults for hover and signature help
--             documentation = {
--               view = "hover",
--               ---@type NoiceViewOptions
--               opts = {
--                 lang = "markdown",
--                 replace = true,
--                 render = "plain",
--                 format = { "{message}" },
--                 win_options = { concealcursor = "n", conceallevel = 3 },
--               },
--             },
--           },
--         })
--
--         require("telescope").load_extension("noice")
--       end,
--       dependencies = {
--         "MunifTanjim/nui.nvim",
--         "rcarriga/nvim-notify",
--       },
--       disable = false,
--     })
--
--
--     if packer_bootstrap then
--       require("packer").sync()
--     end
--   end,
--   config = {
--     opt_default = false,
--     log = "debug",
--     max_jobs = 9,
--     display = {
--       open_fn = function()
--         return require("packer.util").float({ border = "rounded" })
--       end,
--     },
--     luarocks = {
--       python_cmd = "python3",
--     },
--   },
-- })
