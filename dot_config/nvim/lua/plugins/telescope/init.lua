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
				return math.max(100, vim.fn.round(vim.o.columns * 0.4))
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
				"--follow",
				"-uu",
				"--strip-cwd-prefix",
			},
			follow = true,
			hidden = true,
			no_ignore = true,
		},
		buffers = {
			initial_mode = "normal",
			ignore_current_buffer = true,
			sort_lastused = true,
			path_display = { "smart" },
			mappings = {
				n = {
					["<leader><space>"] = actions.close,
				},
			},
		},
		lsp_references = {
			initial_mode = "normal",
		},
		lsp_definitions = {
			initial_mode = "normal",
		},
		lsp_document_symbols = {
			mappings = {
				n = {
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

set("n", "<Leader><space>", function()
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
end, { desc = "Opens buffer switcher, auto-jumps if there's only one buffer" })

map("n", { "<D-p>", "C-S-P" }, function()
	extensions.commander.commander({
		command_list = {
			{
				title = "Find Files",
				type = "command",
				callback = custom_pickers.project_files,
				description = "Find files based on git-ls if in a Git repo, fd otherwise",
			},
			{ title = "Tests", type = "command", callback = custom_pickers.find_tests },
			{
				title = "Buffers",
				type = "command",
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
				type = "command",
				callback = extensions.project.project,
				description = "",
			},
			{
				title = "LSP Document Symbols",
				type = "command",
				callback = builtin.lsp_document_symbols,
				description = "",
			},
			{
				title = "Clipboard History",
				type = "command",
				callback = extensions.neoclip.default,
				description = "",
			},
			{
				title = "Live Grep",
				type = "command",
				callback = builtin.live_grep,
				description = "",
			},
			{
				title = "Snippets",
				type = "command",
				callback = custom_pickers.snippets,
				description = "",
			},
			{
				title = "Todo",
				type = "command",
				callback = extensions["todo-comments"],
				description = "",
			},
			{
				title = "Other buffers",
				type = "command",
				description = "experimental buffer using just vim.ui.select",
				callback = function()
					vim.ui.select(vim.api.nvim_list_bufs(), {
						prompt = "Select a buffer:",
						format_item = function(bufnr)
							return "bufnr: " .. bufnr
						end,
					}, function(choice)
						if choice == "spaces" then
							vim.o.expandtab = true
						else
							vim.o.expandtab = false
						end
					end)
				end,
			},
		},
	})
end)

set("n", "<Leader>f", function()
	custom_pickers.project_files({ prompt_title = "Fuzzy Finder" })
end)

set("n", "<Leader>td", function()
	builtin.diagnostics()
end)

set("n", "<Leader>i", function()
	extensions.commander.related_files()
end)

set("n", "<Leader>p", function()
	extensions.project.project({})
end, { noremap = true, silent = true })

set("n", "<BSlash>s", function()
	builtin.grep_string()
end, { noremap = true, silent = true })

autocmd("FileType", { pattern = "TelescopePrompt", command = "setlocal nocursorline" })

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
