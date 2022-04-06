local set = vim.keymap.set
local extensions = require("telescope").extensions
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_pickers = require("plugins.telescope.pickers")
local autocmd = vim.api.nvim_create_autocmd

require("telescope").setup({
	defaults = {
		set_env = { ["COLORTERM"] = "truecolor" },
		prompt_prefix = "❯ ",
		layout_config = {
			width = function()
				return math.max(100, vim.fn.round(vim.o.columns * 0.3))
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
	},
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")
require("telescope").load_extension("project")
require("telescope").load_extension("zoxide")

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

-- TODO: Move this into the Telescope config
-- set("n", "<C-p>", function()
-- 	custom_pickers.favorites({
-- 		favorites = {
-- 			{ name = "Fuzzy Finder", callback = custom_pickers.project_files },
-- 			{
-- 				name = "Projects",
-- 				callback = function(opt)
-- 					extensions.project.project(opt)
-- 				end,
-- 			},
-- 			-- TODO: There's a delay if the LSP hasn't launched yet I think? Maybe add a loading thing
-- 			{
-- 				name = "LSP Document Symbols",
-- 				callback = builtin.lsp_document_symbols,
-- 			},
-- 			{
-- 				name = "Clipboard History",
-- 				callback = extensions.neoclip.default,
-- 			},
-- 			{
-- 				name = "Live Grep",
-- 				callback = builtin.live_grep,
-- 			},
-- 			{
-- 				name = "Snippets",
-- 				callback = function(opts)
-- 					custom_pickers.snippets(opts)
-- 				end,
-- 			},
-- 			{
-- 				name = "Todo",
-- 				callback = function()
-- 					extensions["todo-comments"].todo()
-- 				end,
-- 			},
-- 			{
-- 				name = "Zoxide",
-- 				callback = extensions.zoxide.list,
-- 			},
-- 		},
-- 	})
-- end)
--
set("n", "<Leader>f", function()
	custom_pickers.project_files({ prompt_title = "Fuzzy Finder" })
end)

set("n", "<Leader>td", function()
	builtin.diagnostics()
end)

set("n", "<Leader>i", function()
	custom_pickers.related_files()
end)

set("n", "<Leader>p", function()
	extensions.project.project({})
end, { noremap = true, silent = true })

set("n", "<BSlash>s", function()
	builtin.grep_string()
end, { noremap = true, silent = true })

autocmd("FileType", { pattern = "TelescopePrompt", command = "setlocal nocursorline" })

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
