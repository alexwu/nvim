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
		use({ "wbthomason/packer.nvim" })
		use({ "lewis6991/impatient.nvim" })
		use({
			"antoinemadec/FixCursorHold.nvim",
			config = function()
				vim.g.curshold_updatime = 250
			end,
		})
		use({ "nvim-lua/plenary.nvim" })
		use({ "~/Code/neovim/nvim-snazzy" })
		use({ "nvim-treesitter/nvim-treesitter" })
		use({ "vigoux/architext.nvim" })
		use({
			"numToStr/Comment.nvim",
			config = function()
				require("plugins.commenting")
			end,
			requires = { "JoosepAlviste/nvim-ts-context-commentstring" },
		})
		use_rocks({ "tl" })
		use_rocks({ "https://raw.github.com/libgit2/luagit2/master/lua-git2-scm-0.rockspec" })
		-- important
		use({
			"sheerun/vim-polyglot",
			setup = function()
				vim.g.polyglot_disabled = { "sensible", "ftdetect", "lua" }
			end,
		})
		use({
			"knubie/vim-kitty-navigator",
			run = "cp ./*.py ~/.config/kitty/",
			config = function()
				require("plugins.kitty")
			end,
		})

		use({
			"mhartington/formatter.nvim",
			config = function()
				require("plugins.formatter")
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
				"weilbith/nvim-code-action-menu",
			},
		})

		use({
			"hrsh7th/nvim-cmp",
			requires = {
				"nvim-lua/plenary.nvim",
				"onsails/lspkind-nvim",
				"hrsh7th/cmp-nvim-lua",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-cmdline",
				"ray-x/cmp-treesitter",
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-buffer",
				"David-Kunz/cmp-npm",
			},
			config = function()
				require("plugins.cmp")
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
			event = "BufEnter",
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
				{ "~/Projects/telescope-project.nvim" },
				{ "~/Projects/neovim/telescope-commander.nvim" },
				{ "nvim-telescope/telescope-hop.nvim" },
				{ "nvim-telescope/telescope-github.nvim" },
			},
			config = function()
				require("plugins.telescope")
			end,
		})

		use({
			"pwntester/octo.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
				"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("octo").setup()
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
				require("statusline")
			end,
		})

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
			"ThePrimeagen/refactoring.nvim",
			requires = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-treesitter/nvim-treesitter" },
			},
			config = function()
				require("refactoring").setup({})
				require("telescope").load_extension("refactoring")

				vim.keymap.set(
					"v",
					"<leader>rr",
					"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
					{ noremap = true }
				)
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
		use({ "jose-elias-alvarez/nvim-lsp-ts-utils" })

		use({
			"simrat39/rust-tools.nvim",
			requires = {
				"nvim-lua/popup.nvim",
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
		})
		use({ "ray-x/go.nvim" })
		use({ "nanotee/sqls.nvim" })

		use({
			"rcarriga/nvim-dap-ui",
			requires = { "mfussenegger/nvim-dap" },
			config = function()
				require("dapui").setup()
			end,
		})

		use({ "gennaro-tedesco/nvim-jqx", ft = { "json" } })
		use({ "kevinhwang91/nvim-bqf" })

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
			"tamago324/lir.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"kyazdani42/nvim-web-devicons",
			},
			config = function()
				require("plugins.lir")
			end,
			disable = true,
		})

		use({
			"akinsho/toggleterm.nvim",
			config = function()
				require("plugins.terminal")
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
			"TimUntersberger/neogit",
			requires = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim" },
			config = function()
				require("neogit").setup({ integrations = { diffview = true } })
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
		use({ "tpope/vim-repeat" })
		use({ "tpope/vim-rails", ft = "ruby" })
		use({ "chaoren/vim-wordmotion" })
		use({ "AndrewRadev/splitjoin.vim" })

		use({
			"karb94/neoscroll.nvim",
			config = function()
				require("plugins.neoscroll")
			end,
		})

		use({
			"beauwilliams/focus.nvim",
			config = function()
				require("plugins.focus")
			end,
		})

		use({
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup({})
			end,
		})

		use({ "rafcamlet/nvim-luapad", ft = { "lua" } })

		use({
			"echasnovski/mini.nvim",
			branch = "stable",
			require = function()
				require("mini.bufremove").setup()
			end,
		})

		use({
			"~/Code/neovim/nvim-treesitter-test-runner",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
				"MunifTanjim/nui.nvim",
			},
		})

		use({
			"~/Projects/neovim/telescope-commander.nvim",
			requires = {
				"nvim-lua/plenary.nvim",
				"nvim-telescope/telescope.nvim",
			},
		})

		use({
			"mrjones2014/legendary.nvim",
			config = function()
				require("plugins.legendary").setup()
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
	},
})
