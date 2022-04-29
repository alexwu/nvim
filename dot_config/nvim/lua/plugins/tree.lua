local lib = require("nvim-tree.lib")
local view = require("nvim-tree.view")
local set = vim.keymap.set
local tree = require("nvim-tree")
local tree_width = require("utils").tree_width

local function collapse_all()
	require("nvim-tree.actions.collapse-all").fn()
end

local function expand_dir()
	local action = "edit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.open-file").fn(action, node.link_to)
		view.close()
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	end
end

local function vsplit_preview()
	-- open as vsplit on current node
	local action = "vsplit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.open-file").fn(action, node.link_to)
	elseif node.nodes ~= nil then
		lib.expand_or_collapse(node)
	else
		require("nvim-tree.actions.open-file").fn(action, node.absolute_path)
	end

	-- Finally refocus on tree if it was lost
	view.focus()
end

local function collapsed_dir_up()
	lib.dir_up()
	lib.collapse_all()
end

local function cd_or_edit()
	local action = "edit"
	local node = lib.get_node_at_cursor()

	-- Just copy what's done normally with vsplit
	if node.link_to and not node.nodes then
		require("nvim-tree.actions.open-file").fn(action, node.link_to)
		view.close()
	elseif node.nodes ~= nil then
		require("nvim-tree.actions.change-dir").fn(lib.get_last_group_node(node).absolute_path)
	else
		require("nvim-tree.actions.open-file").fn(action, node.absolute_path)
	end
end

vim.g.nvim_tree_respect_buf_cwd = 1
vim.g.nvim_tree_highlight_opened_files = 1
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
	auto_reload_on_write = true,
	git = {
		ignore = false,
	},
	disable_netrw = true,
	hijack_netrw = true,
	hijack_cursor = true,
	hijack_unnamed_buffer_when_opening = true,
	update_cwd = true,
	ignore_ft_on_setup = { "startify", "dashboard", "netrw", "help" },
	view = {
		width = tree_width(0.2),
		preserve_window_proportions = true,
		hide_root_folder = true,
		mappings = {
			list = {
				{ key = "-", action = "dir-up", action_cb = collapsed_dir_up },
				{ key = "s", action = "" },
				{ key = "<C-n>", action = "close" },
				{ key = "l", action = "unroll_dir", action_cb = expand_dir },
				{ key = "<CR>", action = "cd", action_cb = cd_or_edit },
				{ key = "L", action = "vsplit_preview", action_cb = vsplit_preview },
				{ key = "h", action = "close_node" },
				{ key = "H", action = "collapse_all", action_cb = collapse_all },
			},
		},
	},
	filters = {
		custom = { ".DS_Store", ".git" },
	},
	update_focused_file = {
		enable = true,
		update_cwd = true,
		ignore_list = { "help" },
	},
	hijack_directories = {
		enable = true,
	},
	diagnostics = {
		enable = true,
	},
	actions = {
		change_dir = {
			global = false,
			restrict_above_cwd = true,
		},
		open_file = {
			quit_on_open = true,
			resize_window = true,
			window_picker = {
				enable = false,
				chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
				exclude = {
					filetype = {
						"notify",
						"packer",
						"qf",
					},
				},
			},
		},
	},
})

local function toggle_replace()
	if view.is_visible() and view.get_bufnr() ~= vim.api.nvim_get_current_buf() then
		view.close()
	end

	tree.open_replacing_current_buffer()
end

set("n", "-", function()
	toggle_replace()
end)

set("n", "<C-n>", "<Cmd>NvimTreeFindFile<CR>")
