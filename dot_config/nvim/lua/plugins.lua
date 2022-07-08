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
    use({ "lewis6991/impatient.nvim" })
    use({
      "antoinemadec/FixCursorHold.nvim",
      config = function()
        vim.g.curshold_updatime = 250
      end,
    })
    use({
      "nvim-lua/plenary.nvim",
      config = function()
        require("plenary.filetype").add_file("extras")
      end,
    })

    use({ "~/Projects/neovim/nvim-snazzy" })
    use({ "nvim-treesitter/nvim-treesitter" })

    use({
      "numToStr/Comment.nvim",
      config = function()
        require("plugins.commenting")
      end,
      requires = { "JoosepAlviste/nvim-ts-context-commentstring" },
    })

    -- important
    use({ "tpope/vim-repeat" })
    use({
      "sheerun/vim-polyglot",
      setup = function()
        vim.g.polyglot_disabled = { "sensible", "ftdetect", "lua" }
      end,
    })

    use({
      "knubie/vim-kitty-navigator",
      run = "cp ./*.py ~/.config/kitty/",
      setup = function()
        vim.g.kitty_navigator_no_mappings = 1
      end,
      config = function()
        require("plugins.kitty")
      end,
      cond = function()
        return vim.env.TERM == "xterm-kitty"
      end,
    })

    use({
      "mhartington/formatter.nvim",
      config = function()
        require("bombeelu.format")
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

    use({
      "neovim/nvim-lspconfig",
      setup = function()
        if not vim.lsp.semantic_tokens then
          vim.lsp.semantic_tokens = require("plugins.lsp.semantic_tokens")
        end
        if not vim.lsp.buf.semantic_tokens_full then
          vim.lsp.buf.semantic_tokens_full = require("plugins.lsp.buf").semantic_tokens_full
        end

        vim.g.code_action_menu_window_border = "rounded"
      end,
      config = function()
        require("plugins.lsp")
      end,
      requires = {
        "williamboman/nvim-lsp-installer",
        "kosayoda/nvim-lightbulb",
        "hrsh7th/cmp-nvim-lsp",
        "nvim-telescope/telescope.nvim",
        "b0o/schemastore.nvim",
        "~/Projects/neovim/nvim-code-action-menu",
      },
    })

    use({
      "hrsh7th/nvim-cmp",
      requires = {
        "David-Kunz/cmp-npm",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "nvim-lua/plenary.nvim",
        "onsails/lspkind-nvim",
        "saadparwaiz1/cmp_luasnip",
        "nvim-treesitter/nvim-treesitter",
        "~/Projects/neovim/cmp-treesitter",
      },
      config = function()
        require("plugins.cmp")
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
    })

    use({
      "tzachar/cmp-tabnine",
      run = "./install.sh",
      requires = "hrsh7th/nvim-cmp",
    })

    use({ "github/copilot.vim", disable = true })
    use({
      "zbirenbaum/copilot.lua",
      event = "InsertEnter",
      config = function()
        vim.schedule(function()
          require("copilot").setup()
        end)
      end,
    })

    use({
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua", "nvim-cmp" },
    })

    use({
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      requires = { "nvim-lua/plenary.nvim" },
      config = function()
        require("crates").setup()
      end,
    })

    use({
      "nvim-telescope/telescope.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
        { "kyazdani42/nvim-web-devicons" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        { "tami5/sqlite.lua", module = "sqlite" },
        { "AckslD/nvim-neoclip.lua" },
        { "~/Projects/neovim/telescope-commander.nvim" },
        { "~/Projects/neovim/telescope-related-files" },
        { "nvim-telescope/telescope-hop.nvim" },
        { "nvim-telescope/telescope-github.nvim" },
      },
      config = function()
        require("plugins.telescope")
      end,
    })

    use({
      "ahmedkhalf/project.nvim",
      config = function()
        require("project_nvim").setup({
          exclude_dirs = { vim.fn.expand("~"), vim.fn.expand("~/.config"), vim.fn.expand("~/.local/share") },
          ignore_lsp = { "null-ls", "null_ls", "null-ls.nvim", "copilot" },
          detection_methods = { "pattern", "lsp" },
          patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json", "Gemfile", "selene.toml" },
          silent_chdir = true,
        })
        require("telescope").load_extension("projects")

        nvim.create_user_command("Projects", function()
          require("telescope").extensions.projects.projects()
        end, {})
      end,
    })
    use({ "MunifTanjim/nui.nvim" })

    use({
      "stevearc/dressing.nvim",
      config = function()
        require("plugins.dressing")
      end,
    })

    use({
      "vim-test/vim-test",
      config = function()
        require("plugins.vim-test")
      end,
      requires = { "akinsho/toggleterm.nvim" },
    })

    use({
      "nvim-lualine/lualine.nvim",
      requires = {
        "kyazdani42/nvim-web-devicons",
        "arkav/lualine-lsp-progress",
        { "SmiteshP/nvim-gps", requires = "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
        require("statusline").setup()
      end,
    })

    use({
      "SmiteshP/nvim-navic",
      requires = "neovim/nvim-lspconfig",
    })

    -- use({
    --   "feline-nvim/feline.nvim",
    --   config = function()
    --     require("statusline").setup("feline")
    --   end,
    -- })
    --
    use({ "nvim-treesitter/nvim-treesitter-textobjects", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "nvim-treesitter/nvim-treesitter-refactor", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "RRethy/nvim-treesitter-textsubjects", requires = "nvim-treesitter/nvim-treesitter" })
    use({ "RRethy/nvim-treesitter-endwise", requires = "nvim-treesitter/nvim-treesitter" })

    use({
      "lewis6991/spellsitter.nvim",
      requires = "nvim-treesitter/nvim-treesitter",
      config = function()
        require("spellsitter").setup()
      end,
    })

    use({
      "lewis6991/hover.nvim",
      config = function()
        require("hover").setup({
          init = function()
            require("hover.providers.lsp")
            require("hover.providers.gh")
            require("hover.providers.man")
          end,
          preview_opts = {
            border = "rounded",
          },
          title = false,
        })

        -- Setup keymaps
        -- vim.keymap.set("n", "K", require("hover").hover, { desc = "hover.nvim" })
        vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "hover.nvim (select)" })
      end,
    })

    use({
      "ThePrimeagen/refactoring.nvim",
      requires = {
        { "nvim-lua/plenary.nvim" },
        { "nvim-treesitter/nvim-treesitter" },
      },
      config = function()
        require("bombeelu.refactoring")
      end,
      disable = true,
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
    })
    use({ "windwp/nvim-ts-autotag" })
    use({ "JoosepAlviste/nvim-ts-context-commentstring" })
    use({
      "andymass/vim-matchup",
      setup = function()
        vim.g.matchup_matchparen_deferred = 1
        vim.g.matchup_matchparen_offscreen = { method = "popup" }
      end,
    })

    use({
      "rcarriga/nvim-notify",
      requires = { "nvim-telescope/telescope.nvim" },
      config = function()
        require("plugins.notify")
      end,
    })

    use({
      "rmagatti/auto-session",
      config = function()
        vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
        require("auto-session").setup({
          auto_session_use_git_branch = true,
        })
      end,
    })

    use({
      "rmagatti/session-lens",
      requires = { "rmagatti/auto-session", "nvim-telescope/telescope.nvim" },
      config = function()
        require("session-lens").setup({})
      end,
    })

    use({
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require("plugins.lsp.null-ls").setup()
      end,
    })

    -- TODO: Once inlay hints are supported
    -- use({ "jose-elias-alvarez/typescript.nvim" })
    use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })

    use({
      "simrat39/rust-tools.nvim",
      requires = {
        "neovim/nvim-lspconfig",
        "hrsh7th/nvim-cmp",
        "nvim-lua/popup.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
    })

    use({
      "ray-x/go.nvim",
      requires = "ray-x/guihua.lua",
      ft = "go",
      config = function()
        require("go").setup()
      end,
    })
    use({ "nanotee/sqls.nvim" })

    use({
      "rcarriga/nvim-dap-ui",
      requires = { "mfussenegger/nvim-dap" },
      config = function()
        require("dapui").setup()
      end,
    })

    use({ "gennaro-tedesco/nvim-jqx", ft = { "json" } })
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
    })

    use({
      "phaazon/hop.nvim",
      requires = { "indianboy42/hop-extensions", "nvim-telescope/telescope.nvim" },
      config = function()
        require("plugins.hop")
      end,
    })

    use({
      "kyazdani42/nvim-tree.lua",
      requires = { "kyazdani42/nvim-web-devicons" },
      config = function()
        require("plugins.tree")
      end,
    })

    use({
      "akinsho/toggleterm.nvim",
      config = function()
        require("plugins.terminal")
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
    })

    use({
      "folke/todo-comments.nvim",
      config = function()
        require("plugins.todo-comments")
      end,
    })

    use({
      "norcalli/nvim-colorizer.lua",
      config = function()
        require("colorizer").setup()
      end,
      cmd = { "ColorizerToggle" },
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
    })

    use({
      "monaqa/dial.nvim",
      config = function()
        require("plugins.dial")
      end,
    })
    use({
      "sindrets/diffview.nvim",
      config = function()
        require("plugins.diffview")
      end,
    })
    use({
      "lukas-reineke/indent-blankline.nvim",
      config = function()
        require("plugins.indent-blankline")
      end,
    })

    use({
      "dsznajder/vscode-es7-javascript-react-snippets",
      run = "yarn install --frozen-lockfile && yarn compile",
    })

    use({
      "lewis6991/spaceless.nvim",
      config = function()
        require("spaceless").setup()
      end,
    })

    use({
      "alexwu/surround.nvim",
      config = function()
        require("surround").setup({ mappings_style = "surround", prompt = false })
      end,
    })

    use({
      "tpope/vim-projectionist",
      requires = { "tpope/vim-dispatch" },
      config = function()
        require("plugins.projectionist")
      end,
    })
    use({ "tpope/vim-fugitive" })
    use({ "tpope/vim-rails", ft = "ruby", disable = true })
    use({ "chaoren/vim-wordmotion" })
    use({ "AndrewRadev/splitjoin.vim" })

    use({
      "declancm/cinnamon.nvim",
      config = function()
        require("cinnamon").setup({
          default_keymaps = true,
          extra_keymaps = false,
        })
      end,
      cond = function()
        return not vim.g.neovide
      end,
    })

    use({
      "beauwilliams/focus.nvim",
      config = function()
        require("plugins.focus")
      end,
      cond = function()
        return vim.fn.exists("g:vscode") ~= 1
      end,
    })

    use({
      "linty-org/key-menu.nvim",
      setup = function()
        vim.o.timeoutlen = 500
      end,
      config = function()
        require("key-menu").set("n", "<Leader>")
        require("key-menu").set("n", "g")
        require("key-menu").set("n", "s")
        require("key-menu").set("n", "<Bslash>")
      end,
    })

    -- neovim plugin development
    use({ "rafcamlet/nvim-luapad", ft = { "lua" } })
    use({ "nanotee/luv-vimdocs" })
    use({ "milisims/nvim-luaref" })
    use({ "folke/lua-dev.nvim" })

    use({
      "echasnovski/mini.nvim",
      branch = "stable",
      require = function()
        require("mini.bufremove").setup()
        -- require("mini.surround").setup({
        --   -- Add custom surroundings to be used on top of builtin ones. For more
        --   -- information with examples, see `:h MiniSurround.config`.
        --   custom_surroundings = nil,
        --
        --   -- Duration (in ms) of highlight when calling `MiniSurround.highlight()`
        --   highlight_duration = 500,
        --
        --   -- Module mappings. Use `''` (empty string) to disable one.
        --   mappings = {
        --     add = "", -- Add surrounding in Normal and Visual modes
        --     delete = "ds", -- Delete surrounding
        --     find = "", -- Find surrounding (to the right)
        --     find_left = "", -- Find surrounding (to the left)
        --     highlight = "", -- Highlight surrounding
        --     replace = "cs", -- Replace surrounding
        --     update_n_lines = "", -- Update `n_lines`
        --   },
        --
        --   -- Number of lines within which surrounding is searched
        --   n_lines = 20,
        --
        --   -- How to search for surrounding (first inside current line, then inside
        --   -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
        --   -- 'cover_or_nearest'. For more details, see `:h MiniSurround.config`.
        --   search_method = "cover",
        -- })
      end,
    })

    use({
      "~/Projects/neovim/spectacle.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        require("spectacle").setup({
          runners = {},
          ft = {
            javascript = { "jest" },
            javascriptreact = { "jest" },
            lua = { "vusted" },
            typescript = { "jest" },
            typescriptreact = { "jest" },
            ruby = { "rspec" },
          },
        })
        require("telescope").load_extension("spectacle")
      end,
      disable = true,
    })

    use({
      "~/Projects/neovim/telescope-commander.nvim",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      disable = false,
    })

    use({
      "mrjones2014/legendary.nvim",
      config = function()
        require("plugins.legendary").setup()
      end,
    })

    use({
      "tami5/xbase",
      run = "make install",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
      },
      ft = { "swift" },
    })

    use({
      "ThePrimeagen/harpoon",
      config = function()
        require("harpoon").setup({
          mark_branch = false,
        })

        vim.keymap.set("n", "gA", function()
          require("harpoon.mark").add_file()
        end)

        vim.keymap.set("n", "gF", function()
          require("harpoon.ui").toggle_quick_menu()
        end)

        require("telescope").load_extension("harpoon")
      end,

      use({
        "rcarriga/neotest",
        config = function()
          require("bombeelu.neotest").setup()
        end,
        requires = {
          "nvim-lua/plenary.nvim",
          "nvim-treesitter/nvim-treesitter",
          "antoinemadec/FixCursorHold.nvim",
          "rcarriga/neotest-vim-test",
          "rcarriga/neotest-plenary",
          "haydenmeade/neotest-jest",
          "olimorris/neotest-rspec",
          "nvim-neotest/neotest-go",
        },
      }),
    })

    use({
      "~/Projects/neovim/ruby.nvim",
      requires = { "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter" },
    })

    use({
      "ericpubu/lsp_codelens_extensions.nvim",
      requires = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
      config = function()
        require("codelens_extensions").setup()
      end,
    })
    use({ "fladson/vim-kitty" })

    use({
      "theHamsta/nvim-semantic-tokens",
      requires = { "neovim/nvim-lspconfig" },
      config = function()
        require("nvim-semantic-tokens").setup({
          preset = "default",
          highlighters = { require("nvim-semantic-tokens.table-highlighter") },
        })
      end,
    })

    use({
      "VonHeikemen/fine-cmdline.nvim",
      requires = {
        { "MunifTanjim/nui.nvim" },
      },
      config = function()
        require("fine-cmdline").setup({
          cmdline = {
            enable_keymaps = true,
            smart_history = true,
            prompt = ": ",
          },
          popup = {
            position = {
              row = "10%",
              col = "50%",
            },
            size = {
              width = "60%",
            },
            border = {
              style = "rounded",
            },
            win_options = {
              winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
            },
          },
          hooks = {
            before_mount = function(input)
              -- code
            end,
            after_mount = function(input)
              -- code
            end,
            set_keymaps = function(imap, feedkeys)
              -- code
            end,
          },
        })
        -- vim.api.nvim_set_keymap("n", ":", "<cmd>FineCmdline<CR>", { noremap = true })
      end,
    })

    use({
      "lewis6991/satellite.nvim",
      config = function()
        require("satellite").setup({ current_only = true })
      end,
    })

    use({
      "sidebar-nvim/sidebar.nvim",
      config = function()
        require("bombeelu.sidebar").setup()
      end,
    })

    use({
      "kevinhwang91/nvim-ufo",
      requires = "kevinhwang91/promise-async",
      config = function()
        vim.wo.foldcolumn = "2"
        vim.wo.foldlevel = 99
        vim.wo.foldenable = true

        vim.keymap.set("n", "zR", require("ufo").openAllFolds)
        vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

        require("ufo").setup({
          provider_selector = function(bufnr, filetype)
            return { "lsp", "treesitter", "indent" }
          end,
        })
      end,
      disable = true,
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
