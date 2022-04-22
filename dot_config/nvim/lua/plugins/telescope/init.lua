local set = vim.keymap.set
local extensions = require("telescope").extensions
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_pickers = require("plugins.telescope.pickers")
local autocmd = vim.api.nvim_create_autocmd

require("telescope").load_extension("fzf")
require("telescope").load_extension("project")
require("telescope").load_extension("commander")

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

require("neoclip").setup({
	enable_persistent_history = true,
})

map("n", "<Leader><space>", function()
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
end, { desc = "Select an open buffer" })

map("n", { "<Leader>b" }, function()
	custom_pickers.buffers({
		initial_mode = "normal",
		ignore_current_buffer = true,
		only_cwd = true,
		sort_lastused = true,
		should_jump = false,
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
				description = "",
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

-- local desc = vim.tbl_filter(function(keymap)
-- 	return keymap.desc ~= nil
-- end, vim.api.nvim_get_commands({}))

-- vim.pretty_print(desc)
for i, entry in ipairs(vim.api.nvim_get_commands({})) do
	vim.pretty_print(entry)
end

set("n", "<Leader>f", function()
	custom_pickers.project_files({ prompt_title = "Find Files" })
end, { desc = "Select files" })

set("n", "<Leader>d", function()
	builtin.diagnostics()
end)

set("n", "<Leader>i", function()
	extensions.commander.related_files()
end, { desc = "Select related files" })

set("n", "<Leader>p", function()
	extensions.project.project({})
end, { noremap = true, silent = true, desc = "Select a project" })

set("n", "<BSlash>s", function()
	builtin.grep_string()
end, { noremap = true, silent = true })

autocmd("FileType", { pattern = "TelescopePrompt", command = "setlocal nocursorline" })

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
