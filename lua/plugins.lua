vim.fn.setenv("MACOSX_DEPLOYMENT_TARGET", "10.15")

local needs_packer = require("utils").needs_packer
local install_packer = require("utils").install_packer

local packer_bootstrap = nil
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if needs_packer(install_path) then
  packer_bootstrap = install_packer(install_path)
end

vim.api.nvim_create_augroup("packer_user_config", { clear = true })
vim.api.nvim_create_autocmd("BufWritePost", {
  group = "packer_user_config",
  pattern = "plugins.lua",
  command = "source <afile> | PackerCompile",
})

return require("packer").startup({
  function()
    -- Minimal setup
    use_rocks({ "penlight", "luafilesystem" })
    use({ "wbthomason/packer.nvim" })
    use({
      "nvim-lua/plenary.nvim",
      config = function()
        require("plenary.filetype").add_file("extras")
      end,
    })

    use({ "lewis6991/impatient.nvim" })

    use({ "tpope/vim-repeat" })

    -- use({ "alexwu/nvim-snazzy", requires = "rktjmp/lush.nvim", branch = "lush" })
    use({ "~/Projects/neovim/nvim-snazzy", requires = "rktjmp/lush.nvim" })

    use({
      "nvim-treesitter/nvim-treesitter",
      requires = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-refactor",
        "RRethy/nvim-treesitter-textsubjects",
        "RRethy/nvim-treesitter-endwise",
        "JoosepAlviste/nvim-ts-context-commentstring",
      },
      config = function()
        require("plugins.treesitter")
      end,
    })

    use({
      "nvim-treesitter/nvim-treesitter-context",
      requires = "nvim-treesitter/nvim-treesitter",
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
    })

    use({
      "numToStr/Comment.nvim",
      config = function()
        require("plugins.commenting")
      end,
      requires = { "JoosepAlviste/nvim-ts-context-commentstring" },
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "phaazon/hop.nvim",
      requires = { "nvim-telescope/telescope.nvim", "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("plugins.hop")
      end,
    })

    use({
      "kylechui/nvim-surround",
      config = function()
        require("nvim-surround").setup({})
      end,
    })

    use({
      "monaqa/dial.nvim",
      config = function()
        require("plugins.dial")
      end,
    })

    use({
      "rcarriga/nvim-notify",
      requires = { "nvim-telescope/telescope.nvim" },
      config = function()
        if not vim.g.vscode then
          require("plugins.notify")
        end
      end,
    })

    -- use({
    --   "sheerun/vim-polyglot",
    --   setup = function()
    --     vim.g.polyglot_disabled = { "sensible", "ftdetect", "lua" }
    --   end,
    --   cond = function()
    --     return not vim.g.vscode
    --   end,
    -- })

    use({
      "knubie/vim-kitty-navigator",
      run = "cp ./*.py ~/.config/kitty/",
      setup = function()
        vim.g.kitty_navigator_no_mappings = 0
      end,
      config = function()
        require("plugins.kitty")
      end,
      cond = function()
        return vim.env.TERM == "xterm-kitty" and not vim.g.vscode
      end,
    })

    use({
      "mhartington/formatter.nvim",
      config = function()
        require("bombeelu.format")
      end,
    })

    use({
      "williamboman/mason.nvim",
      requires = { "williamboman/mason-lspconfig.nvim", "neovim/nvim-lspconfig" },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "L3MON4D3/LuaSnip",
      requires = {
        "rafamadriz/friendly-snippets",
      },
      config = function()
        require("plugins.snippets")
      end,
    })

    use({ "onsails/lspkind-nvim", opt = false })

    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "David-Kunz/cmp-npm",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "onsails/lspkind-nvim",
        "saadparwaiz1/cmp_luasnip",
        "~/Projects/neovim/cmp-treesitter",
        "tzachar/cmp-tabnine",
      },
      config = function()
        if not vim.g.vscode then
          require("plugins.cmp")
        end
      end,
    })

    use({
      "tzachar/cmp-tabnine",
      run = "./install.sh",
      requires = "hrsh7th/nvim-cmp",
      after = "nvim-cmp",
      config = function()
        if not vim.g.vscode then
          local tabnine = require("cmp_tabnine.config")
          tabnine:setup({
            max_lines = 1000,
            max_num_results = 20,
            sort = true,
            run_on_every_keystroke = true,
            snippet_placeholder = "..",
            ignored_file_types = {},
            show_prediction_strength = true,
          })
        end
      end,
    })

    use({
      "neovim/nvim-lspconfig",
      config = function()
        if not vim.g.vscode then
          require("plugins.lsp")
        end
      end,
      requires = {
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "kosayoda/nvim-lightbulb",
        "nvim-telescope/telescope.nvim",
        "b0o/schemastore.nvim",
        "simrat39/inlay-hints.nvim",
        "stevearc/dressing.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "theHamsta/nvim-semantic-tokens",
      },
      after = {
        "nvim-cmp",
      },
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "theHamsta/nvim-semantic-tokens",
      config = function()
        require("nvim-semantic-tokens").setup({
          preset = "default",
          highlighters = { require("nvim-semantic-tokens.table-highlighter") },
        })
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "ray-x/lsp_signature.nvim",
      config = function()
        require("lsp_signature").setup({
          bind = true,
          handler_opts = {
            border = "rounded",
          },
        })
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "zbirenbaum/copilot.lua",
      requires = { "hrsh7th/nvim-cmp" },
      event = "InsertEnter",
      config = function()
        vim.schedule(function()
          require("copilot").setup()
        end)
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "zbirenbaum/copilot-cmp",
      requires = { "hrsh7th/nvim-cmp", "zbirenbaum/copilot.lua" },
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
    })

    use({
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup()
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "nvim-telescope/telescope-fzf-native.nvim",
      run = "make",
      requires = { "nvim-telescope/telescope.nvim" },
      config = function()
        if not vim.g.vscode then
          require("telescope").load_extension("fzf")
        end
      end,
    })

    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "kyazdani42/nvim-web-devicons",
        { "tami5/sqlite.lua", module = "sqlite" },
        "AckslD/nvim-neoclip.lua",
      },
      config = function()
        if not vim.g.vscode then
          require("plugins.telescope")
        end
      end,
    })

    use({
      "smartpde/telescope-recent-files",
      requires = "nvim-telescope/telescope.nvim",
      config = function()
        require("telescope").load_extension("recent_files")
      end,
    })

    use({
      "axkirillov/easypick.nvim",
      requires = "nvim-telescope/telescope.nvim",
      config = function()
        local easypick = require("easypick")

        easypick.setup({
          pickers = {
            {
              name = "conflicts",
              command = "git diff --name-only --diff-filter=U --relative",
              previewer = easypick.previewers.file_diff(),
            },
          },
        })
      end,
    })

    use({ "MunifTanjim/nui.nvim" })

    use({
      "stevearc/dressing.nvim",
      config = function()
        require("plugins.dressing")
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "andrewferrier/textobj-diagnostic.nvim",
      config = function()
        if not vim.g.vscode then
          require("textobj-diagnostic").setup()
        end
      end,
    })

    use({
      "smjonas/inc-rename.nvim",
      config = function()
        require("inc_rename").setup({
          input_buffer_type = "dressing",
        })

        vim.keymap.set("n", "<leader>rn", function()
          return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true })
      end,
    })

    use({
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup({
          exclude_dirs = {
            vim.fs.normalize("~"),
            vim.fs.normalize("~/.config"),
            vim.fs.normalize("~/.local/share"),
            vim.fs.normalize("~/.cargo"),
          },
          ignore_lsp = { "null-ls", "null_ls", "null-ls.nvim", "copilot" },
          detection_methods = { "pattern", "lsp" },
          patterns = {
            ".git",
            "_darcs",
            ".hg",
            ".bzr",
            ".svn",
            "Makefile",
            "package.json",
            "Gemfile",
            "selene.toml",
            "justfile",
            "!.cargo/",
            "!.rustup/",
            "!.node_modules/",
            "!.config/",
          },
          silent_chdir = true,
        })
        require("telescope").load_extension("projects")

        nvim.create_user_command("Projects", function()
          require("telescope").extensions.projects.projects()
        end, {})

        vim.keymap.set("n", "<leader>p", function()
          require("telescope").extensions.projects.projects()
        end, { desc = "Select a project" })
      end,
      requires = { "nvim-telescope/telescope.nvim" },
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "vim-test/vim-test",
      config = function()
        require("plugins.vim-test")
      end,
      requires = { "akinsho/toggleterm.nvim" },
      cond = function()
        return not vim.g.vscode
      end,
      cmd = { "TestFile", "TestNearest" },
    })

    use({
      "nvim-lualine/lualine.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons",
        { "SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter" },
        "SmiteshP/nvim-navic",
      },
      config = function()
        require("statusline").setup()
      end,
    })

    use({
      "SmiteshP/nvim-navic",
      requires = { "neovim/nvim-lspconfig" },
      config = function()
        require("nvim-navic").setup({
          icons = {
            File = " ",
            Module = " ",
            Namespace = " ",
            Package = " ",
            Class = " ",
            Method = " ",
            Property = " ",
            Field = " ",
            Constructor = " ",
            Enum = " ",
            Interface = " ",
            Function = " ",
            Variable = " ",
            Constant = " ",
            String = " ",
            Number = " ",
            Boolean = " ",
            Array = " ",
            Object = " ",
            Key = " ",
            Null = " ",
            EnumMember = " ",
            Struct = " ",
            Event = " ",
            Operator = " ",
            TypeParameter = " ",
          },
          highlight = true,
        })
      end,
    })

    use({
      "nvim-treesitter/playground",
      cmd = { "TSHighlightCapturesUnderCursor", "TSPlaygroundToggle", "TSNodeUnderCursor" },
    })

    use({
      "windwp/nvim-autopairs",
      config = function()
        require("plugins.autopairs")
      end,
      requires = { "hrsh7th/nvim-cmp" },
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "windwp/nvim-ts-autotag",
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "andymass/vim-matchup",
      setup = function()
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
      cond = function()
        return not vim.g.vscode
      end,
      disable = false,
    })

    use({
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("plugins.indent-blankline")
      end,
      requires = "nvim-treesitter/nvim-treesitter",
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      requires = { "lewis6991/gitsigns.nvim", "williamboman/mason.nvim" },
      config = function()
        require("plugins.lsp.null-ls").setup()
      end,
    })

    use({
      "jose-elias-alvarez/typescript.nvim",
      ft = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
      cond = function()
        return not vim.g.vscode
      end,
      config = function()
        require("bombeelu.lsp").typescript.setup()
      end,
    })

    use({
      "simrat39/rust-tools.nvim",
      ft = "rust",
      requires = {
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
    })

    -- use({
    --   "ray-x/go.nvim",
    --   requires = "ray-x/guihua.lua",
    --   ft = "go",
    --   config = function()
    --     require("bombeelu.lsp.go").setup()
    --   end,
    --   cond = function()
    --     return not vim.g.vscode
    --   end,
    -- })

    --       use({
    --         "nanotee/sqls.nvim",
    --         cond = function()
    --           return not vim.g.vscode
    --         end,
    --       })

    use({
      "mfussenegger/nvim-dap",
      requires = {
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text",
        "mxsdev/nvim-dap-vscode-js",
      },
      config = function()
        require("bombeelu.dap").setup()
      end,
    })

    use({
      "microsoft/vscode-js-debug",
      opt = true,
      run = "npm install --legacy-peer-deps && npm run compile",
    })

    use({
      "gennaro-tedesco/nvim-jqx",
      ft = { "json" },
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "kevinhwang91/nvim-bqf",
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
    })

    use({
      "kyazdani42/nvim-tree.lua",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
        require("plugins.tree")
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "akinsho/toggleterm.nvim",
      config = function()
        require("plugins.terminal")
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "da-moon/telescope-toggleterm.nvim",
      event = "TermOpen",
      requires = {
        "akinsho/toggleterm.nvim",
        "nvim-telescope/telescope.nvim",
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
      },
      config = function()
        require("telescope").load_extension("toggleterm")
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "folke/todo-comments.nvim",
      config = function()
        require("plugins.todo-comments")
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
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
    })

    use({
      "lewis6991/gitsigns.nvim",
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("plugins.gitsigns")
      end,
    })

    use({
      "akinsho/git-conflict.nvim",
      config = function()
        require("git-conflict").setup({
          disable_diagnostics = true,
        })
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "sindrets/diffview.nvim",
      config = function()
        require("plugins.diffview")
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "dsznajder/vscode-es7-javascript-react-snippets",
      run = "yarn install --frozen-lockfile && yarn compile",
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "lewis6991/spaceless.nvim",
      config = function()
        require("spaceless").setup()
      end,
      cond = function()
        return not vim.g.vscode
      end,
      event = "InsertEnter",
    })

    use({
      "tpope/vim-projectionist",
      requires = { "tpope/vim-dispatch" },
      cond = function()
        return not vim.g.vscode
      end,
    })
    use({ "tpope/vim-fugitive" })
    use({ "tpope/vim-rails", ft = "ruby", disable = true })
    use({ "chaoren/vim-wordmotion", disable = false })
    use({ "AndrewRadev/splitjoin.vim", disable = true })

    use({
      "beauwilliams/focus.nvim",
      config = function()
        require("plugins.focus")
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "linty-org/key-menu.nvim",
      setup = function()
        vim.o.timeoutlen = 500
      end,
      config = function()
        require("key-menu").set("n", "<Leader>")
        require("key-menu").set("n", "s")
        require("key-menu").set("n", "[")
        require("key-menu").set("n", "]")
        require("key-menu").set("n", "<Bslash>")
      end,
      cond = function()
        return vim.g.vscode
      end,
    })

    use({
      "folke/lua-dev.nvim",
      ft = "lua",
      requires = {
        "neovim/nvim-lspconfig",
        "hrsh7th/nvim-cmp",
      },
      config = function()
        require("bombeelu.lsp").lua.setup()
      end,
      cond = function()
        return vim.g.vscode
      end,
    })

    use({
      "echasnovski/mini.nvim",
      branch = "stable",
      require = function()
        require("mini.bufremove").setup({})
      end,
    })

    --       use({
    --         "~/Projects/neovim/spectacle.nvim",
    --         requires = {
    --           "nvim-lua/plenary.nvim",
    --           "nvim-telescope/telescope.nvim",
    --           "MunifTanjim/nui.nvim",
    --         },
    --         config = function()
    --           require("spectacle").setup({
    --             runners = {},
    --             ft = {
    --               javascript = { "jest" },
    --               javascriptreact = { "jest" },
    --               lua = { "vusted" },
    --               typescript = { "jest" },
    --               typescriptreact = { "jest" },
    --               ruby = { "rspec" },
    --             },
    --           })

    --           require("telescope").load_extension("spectacle")
    --         end,
    --         disable = true,
    --       })

    -- use({
    --   "~/Projects/neovim/telescope-commander.nvim",
    --   requires = {
    --     "nvim-lua/plenary.nvim",
    --     "nvim-telescope/telescope.nvim",
    --   },
    --   cond = function()
    --     return vim.g.vscode
    --   end,
    -- })
    --

    use({
      "~/Projects/neovim/ruby.nvim",
      requires = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
      config = function()
        require("bombeelu.lsp").sorbet.setup()
      end,
      disable = false,
    })

    use({
      "simrat39/inlay-hints.nvim",
      config = function()
        if not vim.g.vscode then
          require("inlay-hints").setup({
            renderer = "inlay-hints/render/eol",
            hints = {
              parameter = {
                show = false,
                highlight = "LspInlayHints",
              },
              type = {
                show = true,
                highlight = "LspInlayHints",
              },
            },
            only_current_line = false,
            eol = {
              right_align = false,
              right_align_padding = 7,
              parameter = {
                separator = ", ",
                format = function(hints)
                  return string.format(" <- (%s)", hints)
                end,
              },

              type = {
                separator = ", ",
                format = function(hints)
                  return string.format(" => (%s)", hints)
                end,
              },
            },
          })
        end
      end,
    })

    use({
      "j-hui/fidget.nvim",
      config = function()
        require("fidget").setup({
          sources = {
            ["null-ls"] = {
              ignore = true,
            },
          },
        })
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "mrshmllow/document-color.nvim",
      config = function()
        require("document-color").setup({})
      end,
    })

    use({
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({ virtual_lines = false })

        vim.keymap.set("n", "gl", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
      end,
    })

    use({
      "andrewferrier/debugprint.nvim",
      config = function()
        require("debugprint").setup()
      end,
      disable = true,
    })

    use({
      "kevinhwang91/nvim-ufo",
      requires = "kevinhwang91/promise-async",
      config = function()
        require("bombeelu.folds").setup()
      end,
      cond = function()
        return not vim.g.vscode
      end,
    })

    use({
      "jghauser/kitty-runner.nvim",
      config = function()
        -- require("kitty-runner").setup()
      end,
    })

    use({
      "IndianBoy42/tree-sitter-just",
      config = function()
        require("tree-sitter-just").setup()
      end,
      disable = true,
    })

    use({
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
    })

    use({
      "ziontee113/syntax-tree-surfer",
      config = function()
        require("bombeelu.syntax-tree-surfer").setup()
      end,
    })

    use({
      "luukvbaal/stabilize.nvim",
      config = function()
        require("stabilize").setup()
      end,
    })

    use({
      "nvim-neotest/neotest",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "haydenmeade/neotest-jest",
        "olimorris/neotest-rspec",
      },
      config = function()
        require("bombeelu.neotest").setup()
      end,
    })

    use({
      "vigoux/notifier.nvim",
      config = function()
        require("notifier").setup({})
      end,
      disable = true,
    })

    use({
      "narutoxy/dim.lua",
      requires = { "nvim-treesitter/nvim-treesitter", "neovim/nvim-lspconfig" },
      config = function()
        require("dim").setup({
          disable_lsp_decorations = true,
        })
      end,
    })

    use({
      "ggandor/leap.nvim",
      config = function()
        require("leap").setup({
          highlight_unlabled = true,
          max_aot_targets = 2,
        })

        set("n", "<Tab>", function()
          require("leap").leap({ target_windows = { vim.fn.win_getid() } })
        end)
      end,
      disable = false,
    })

    use({
      "lewis6991/satellite.nvim",
      config = function()
        if not vim.g.vscode then
          require("satellite").setup({
            current_only = true,
          })
        end
      end,
    })

    use({
      "nvim-telescope/telescope-dap.nvim",
      requires = { "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap" },
      config = function()
        require("telescope").load_extension("dap")
      end,
    })

    use({
      "aarondiel/spread.nvim",
      after = "nvim-treesitter",
      config = function()
        local spread = require("spread")
        local default_options = { silent = true, noremap = true }

        vim.keymap.set("n", "gS", spread.out, default_options)
        vim.keymap.set("n", "gJ", spread.combine, default_options)
      end,
    })

    use({
      "tversteeg/registers.nvim",
      setup = function()
        vim.g.registers_window_border = "rounded"
      end,
    })

    if packer_bootstrap then
      require("packer").sync()
    end
  end,
  config = {
    opt_default = false,
    log = "debug",
    max_jobs = 9,
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
    },
    luarocks = {
      python_cmd = "python3",
    },
  },
})
