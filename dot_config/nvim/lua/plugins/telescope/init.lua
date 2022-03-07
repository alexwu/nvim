local set = vim.keymap.set
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local utils = require("telescope.utils")

R = function(name)
	require("plenary.reload").reload_module(name)
	return require(name)
end

require("telescope").setup({
	defaults = {
		set_env = { ["COLORTERM"] = "truecolor" },
		prompt_prefix = "❯ ",
		layout_config = {
			width = function()
				return math.max(100, vim.fn.round(vim.o.columns * 0.3))
			end,
			height = function(_, _, max_lines)
				return math.min(max_lines, 15)
			end,
		},
		sorting_strategy = "ascending",
		layout_strategy = "center",
		winblend = 10,
		mappings = {
			i = {
				["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-u>"] = false,
			},
			n = {
				["q"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
		theme = "dropdown",
	},
	pickers = {
		builtin = {
			theme = "dropdown",
		},
		find_files = {
			find_command = {
				"fd",
				"--type",
				"f",
				"--follow",
				"-uu",
				"--strip-cwd-prefix",
			},
		},
		git_files = {
			theme = "dropdown",
			layout_config = {
				width = function()
					return math.max(100, vim.fn.round(vim.o.columns * 0.3))
				end,
			},
		},
		git_status = {
			theme = "dropdown",
			layout_config = {
				width = function()
					return math.max(100, vim.fn.round(vim.o.columns * 0.3))
				end,
			},
		},
		live_grep = {
			theme = "dropdown",
		},
		buffers = {
			initial_mode = "normal",
			theme = "dropdown",
			ignore_current_buffer = true,
			sort_lastused = true,
			layout_config = {
				width = function()
					return math.max(100, vim.fn.round(vim.o.columns * 0.3))
				end,
			},
			path_display = { "smart" },
			mappings = {
				n = {
					["<leader><space>"] = actions.close,
				},
			},
		},
		lsp_references = {
			theme = "dropdown",
			initial_mode = "normal",
		},
		lsp_definitions = {
			theme = "dropdown",
			initial_mode = "normal",
		},
		lsp_document_symbols = {
			mappings = {
				i = {
					["-"] = actions.close,
				},
			},
		},
	},
	extensions = {
		fzf = {
			fuzzy = true,
			override_generic_sorter = true,
			override_file_sorter = true,
			case_mode = "smart_case",
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				layout_config = {
					width = function()
						return math.max(100, vim.fn.round(vim.o.columns * 0.3))
					end,
					height = function(_, _, max_lines)
						return math.min(max_lines, 15)
					end,
				},
			}),
		},
		project = {
			base_dirs = {},
			hidden_files = true,
		},
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("project")

require("neoclip").setup({
	enable_persistent_history = true,
})

set("n", "<Leader><space>", function()
	require("plugins.telescope.pickers").buffers({
		initial_mode = "normal",
		theme = "dropdown",
		ignore_current_buffer = true,
		only_cwd = true,
		sort_lastused = true,
		layout_config = {
			width = function()
				return math.max(100, vim.fn.round(vim.o.columns * 0.3))
			end,
		},
		path_display = { "smart" },
		mappings = {
			n = {
				["<leader><space>"] = actions.close,
			},
		},
	})
end)

-- set("n", "gf", function()
-- 	builtin.find_files(
-- 		require("telescope.themes").get_dropdown({
-- 			layout_config = {
-- 				width = function()
-- 					return math.max(100, vim.fn.round(vim.o.columns * 0.3))
-- 				end,
-- 			},
-- 		}),
-- 		{ desc = "Find Files" }
-- 	)
-- end, { desc = "Default fuzzy finder" })
--
set("n", "<Leader>f", function()
	require("plugins.telescope.pickers").project_files({ prompt_title = "Files" })
end)

set("n", "<Leader>tp", function()
	builtin.builtin({ include_extensions = true })
end)

set("n", "<Leader>td", function()
	builtin.diagnostics()
end)

set("n", "gag", function()
	builtin.live_grep()
end)

set("n", "gbr", function()
	builtin.git_branches()
end)

set("n", "<Leader>sn", function()
	require("plugins.telescope.pickers").snippets()
end)

set("n", "<Leader>st", function()
	builtin.git_status()
end)

set("n", "<Leader>i", function()
	require("plugins.telescope.pickers").related_files()
end)

set("n", "gp", function()
	require("telescope").extensions.neoclip.default()
end)

set("n", "<Leader>p", function()
	require("telescope").extensions.project.project({})
end, { noremap = true, silent = true })

vim.cmd([[autocmd FileType TelescopePrompt setlocal nocursorline]])
vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
