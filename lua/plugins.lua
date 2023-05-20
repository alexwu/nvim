vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")

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
    enabled = true,
  },
  {
    "xiyaowong/transparent.nvim",
    dependencies = { "nvim-snazzy" },
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          "Normal",
          "NormalNC",
          "Comment",
          "Constant",
          "Special",
          "Identifier",
          "Statement",
          "PreProc",
          "Type",
          "Underlined",
          "Todo",
          "String",
          "Function",
          "Conditional",
          "Repeat",
          "Operator",
          "Structure",
          "LineNr",
          "NonText",
          "SignColumn",
          "CursorLineNr",
          "EndOfBuffer",
        },
        extra_groups = {},   -- table: additional groups that should be cleared
        exclude_groups = {}, -- table: groups you don't want to clear
      })
    end,
    enabled = true,
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
    { "tpope/vim-repeat", lazy = false },
    "sheerun/vim-polyglot",
    lazy = false,
    init = function()
      vim.g.polyglot_disabled = { "sensible", "ftdetect" }
    end,
  },
  { "antoinemadec/FixCursorHold.nvim", lazy = false },
  {
    "chrisgrieser/nvim-spider",
    config = function()
      require("spider").setup({
        skipInsignificantPunctuation = false,
      })

      vim.keymap.set({ "n", "o", "x" }, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-w" })
      vim.keymap.set({ "n", "o", "x" }, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-w" })
    end,
  },
  {
    "Wansmer/treesj",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup({
        enabled = true,
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
      "nvim-telescope/telescope.nvim",
    },
  },
  {
    "ggandor/flit.nvim",
    dependencies = { "ggandor/leap.nvim" },
    config = function()
      require("flit").setup({
        keys = { f = "f", F = "F", t = "t", T = "T" },
        labeled_modes = "v",
        multiline = true,
        opts = {},
      })
    end,
  },
  {
    "ggandor/leap-spooky.nvim",
    dependencies = { "ggandor/leap.nvim" },
    config = function()
      require("leap-spooky").setup({
        affixes = {
          remote = { window = "r", cross_window = "R" },
          magnetic = { window = "m", cross_window = "M" },
        },
        paste_on_remote_yank = false,
      })
    end,
  },
  {
    "mhartington/formatter.nvim",
    config = function()
      require("bombeelu.format")
    end,
  },
  {
    "numToStr/FTerm.nvim",
    config = function()
      require("FTerm").setup({
        border = "rounded",
      })

      local commands = require("legendary").commands

      commands({
        { ":FTermOpen",   require("FTerm").open,   description = "Open terminal",   opts = { bang = true } },
        { ":FTermClose",  require("FTerm").close,  description = "Close terminal",  opts = { bang = true } },
        { ":FTermExit",   require("FTerm").exit,   description = "Exit terminal",   opts = { bang = true } },
        { ":FTermToggle", require("FTerm").toggle, description = "Toggle terminal", opts = { bang = true } },
      })

      vim.api.nvim_create_user_command("YarnTest", function()
        require("FTerm").run({ "yarn", "test" })
      end, { bang = true })
      key.map({ [[<C-\>]], [[<C-`>]] }, require("FTerm").toggle, { desc = "Toggle terminal", modes = { "n", "t" } })
    end,
  },

  {
    "aarondiel/spread.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local spread = require("spread")
      local default_options = { silent = true, noremap = true }

      vim.keymap.set("n", "gS", spread.out, default_options)
      vim.keymap.set("n", "gJ", spread.combine, default_options)
    end,
    enabled = false,
  },
  {
    "nvim-neotest/neotest",
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
  },
  {
    dependencies = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
    "alexwu/ruby.nvim",
    dev = true,
    config = function()
      require("bombeelu.lsp").sorbet.setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
    ft = { "ruby" },
    enabled = true,
  },
  {
    "ckolkey/ts-node-action",
    dependencies = { "nvim-treesitter" },
    config = function()
      require("ts-node-action").setup({})
      vim.keymap.set({ "n" }, "gJ", require("ts-node-action").node_action, { desc = "Trigger Node Action" })
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
    "stevearc/dressing.nvim",
    config = function()
      require("plugins.dressing")
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end,
  },
  {
    "smjonas/inc-rename.nvim",
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
    setup = function()
      vim.g.matchup_matchparen_deferred = 1
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
    cond = function()
      return not vim.g.vscode
    end,
    enabled = false,
  },
  {
    "ziontee113/syntax-tree-surfer",
    config = function()
      require("bombeelu.syntax-tree-surfer").setup()
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "akinsho/git-conflict.nvim",
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
    "nvim-treesitter/playground",
    cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle", "TSNodeUnderCursor" },
  },
  {
    "ray-x/go.nvim",
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
    config = true,
  },

  -- Lua
  {
    "folke/trouble.nvim",
    requires = "nvim-tree/nvim-web-devicons",
    config = true,
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
    "NvChad/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup({
        filetypes = { "*" },
        user_default_options = {
          names = false, -- "Name" codes like Blue or blue
        },
        -- all the sub-options of filetypes apply to buftypes
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
  { "shortcuts/no-neck-pain.nvim",     version = "*" },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup()
    end,
    lazy = false,
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
--
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
--
--     use({
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
--
--     use({
--       "tpope/vim-projectionist",
--       dependencies = { "tpope/vim-dispatch" },
--       cond = function()
--         return not vim.g.vscode
--       end,
--     })

--     use({ "tpope/vim-rails", ft = "ruby", disable = true })
--     use({
--       "beauwilliams/focus.nvim",
--       config = function()
--         if not vim.g.vscode then
--           require("plugins.focus")
--         end
--       end,
--     })
--
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
--
--     use({ "junegunn/vim-easy-align" })
--
