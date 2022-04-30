local set = vim.keymap.set
local extensions = require("telescope").extensions
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_pickers = require("plugins.telescope.pickers")
local autocmd = vim.api.nvim_create_autocmd
local lazy = require("bombeelu.utils").lazy

require("telescope").setup({
	defaults = {
		set_env = { ["COLORTERM"] = "truecolor" },
		prompt_prefix = "❯ ",
		layout_config = {
			width = function()
				return math.max(100, vim.fn.round(vim.o.columns * 0.5))
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
	},
	pickers = {
		find_files = {
			find_command = {
				"fd",
				"--type",
				"f",
				"--strip-cwd-prefix",
			},
			follow = true,
			hidden = true,
			no_ignore = true,
		},
		buffers = {
			initial_mode = "normal",
			ignore_current_buffer = true,
			cwd_only = true,
			sort_lastused = true,
			path_display = { "smart" },
			mappings = {
				n = {
					["<leader><space>"] = actions.close,
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
			base_dirs = {
				"~/Code",
				"~/Projects",
			},
			hidden_files = true,
			mappings = {
				n = {
					["<leader><space>"] = actions.close,
				},
			},
			load_session = true,
		},
		commander = {},
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("project")
require("telescope").load_extension("commander")

require("neoclip").setup({
	enable_persistent_history = true,
})

map("n", { "<Leader>b" }, function()
	builtin.buffers({
		initial_mode = "normal",
		ignore_current_buffer = true,
		only_cwd = true,
		sort_lastused = true,
		path_display = { "smart" },
		mappings = {
			n = {
				["<leader><space>"] = actions.close,
			},
		},
	})
end, { desc = "Select an open buffer" })

map("n", { "<D-p>", "<C-S-P>" }, function()
	extensions.commander.commander({
		command_list = {
			{
				title = "Find Files",
				callback = custom_pickers.project_files,
				description = "Select files from current directory",
			},
			{ title = "Tests", callback = custom_pickers.find_tests },
			{
				title = "Buffers",
				callback = function()
					custom_pickers.buffers({
						initial_mode = "normal",
						ignore_current_buffer = true,
						only_cwd = true,
						sort_lastused = true,
						path_display = { "smart" },
						mappings = {
							n = {
								["<leader><space>"] = actions.close,
							},
						},
					})
				end,
			},
			{
				title = "Projects",
				callback = extensions.project.project,
				description = "Select a project",
			},
			{
				title = "LSP Document Symbols",
				callback = builtin.lsp_document_symbols,
				description = "Select a document symbol from LSP",
			},
			{
				title = "Clipboard History",
				callback = extensions.neoclip.default,
				description = "Select from clipboard history",
			},
			{
				title = "Live Grep",
				callback = builtin.live_grep,
				description = "Grep the current directory",
			},
			{
				title = "Snippets",
				callback = custom_pickers.snippets,
				description = "Select snippet based on current file",
			},
			{
				title = "Todo",
				callback = extensions["todo-comments"],
				description = "Select a todo from the current directory",
			},
		},
	})
end)

set("n", "<Leader>f", lazy(custom_pickers.project_files, { prompt_title = "Find Files" }), { desc = "Select files" })
set("n", "<Leader>d", lazy(builtin.diagnostics))

map(
	"n",
	{ "<leader><space>", "<Leader>i" },
	lazy(extensions.commander.related_files),
	{ desc = "Select related files" }
)

set("n", "<Leader>p", function()
	extensions.project.project({})
end, { noremap = true, silent = true, desc = "Select a project" })

autocmd("FileType", { pattern = "TelescopePrompt", command = "setlocal nocursorline" })

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
