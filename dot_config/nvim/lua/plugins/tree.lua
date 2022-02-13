local set = vim.keymap.set
local tree = require("nvim-tree")
local tree_cb = require("nvim-tree.config").nvim_tree_callback
local tree_width = require("utils").tree_width

vim.g.nvim_tree_disable_window_picker = 1
vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_highlight_opened_files = 1
vim.g.nvim_tree_quit_on_open = 1
vim.g.nvim_tree_icons = {
	default = "",
	symlink = "",
	git = {
		unstaged = "✗",
		staged = "✓",
		unmerged = "",
		renamed = "➜",
		untracked = "+",
		deleted = "",
	},
	folder = {
		arrow_open = "",
		arrow_closed = "",
		default = "",
		open = "",
		empty = "",
		empty_open = "",
		symlink = "",
		symlink_open = "",
	},
	lsp = {
		hint = "",
		info = "",
		warning = "",
		error = "",
	},
}

vim.g.nvim_tree_special_files = {
	["Gemfile"] = 1,
	["Gemfile.lock"] = 1,
	["package.json"] = 1,
}
vim.g.show_icons = {
	git = 1,
	folders = 1,
	files = 1,
	folder_arrows = 1,
}

tree.setup({
	auto_close = true,
	auto_reload_on_write = true,
	git = {
		ignore = "no",
	},
	disable_netrw = true,
	hijack_netrw = true,
	ignore_ft_on_setup = { "startify", "dashboard", "netrw", "help" },
	view = {
		auto_resize = true,
		width = tree_width(0.2),
		mappings = {
			list = {
				{ key = "h", cb = tree_cb("close_node") },
				{ key = "l", cb = tree_cb("unroll_dir") },
				{ key = "-", cb = nil },
				{ key = "<C-n>", cb = tree_cb("close") },
			},
		},
		filters = {
			custom = { ".DS_Store", ".git" },
		},
	},
	update_focused_file = {
		enable = true,
		update_cwd = false,
		ignore_list = { "help" },
	},
	update_to_buf_dir = {
		enable = false,
	},
	diagnostics = {
		enable = true,
	},
})

set("n", "<C-n>", "<Cmd>NvimTreeFindFile<CR>")
