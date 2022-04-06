local set = vim.keymap.set
local Terminal = require("toggleterm.terminal").Terminal

local lazygit = Terminal:new({
	cmd = "lazygit",
	direction = "float",
	hidden = true,
})

vim.api.nvim_add_user_command("LazyGit", function()
	lazygit:toggle()
end, { nargs = 0 })

vim.api.nvim_add_user_command("LG", function()
	lazygit:toggle()
end, { nargs = 0 })

require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.8
		end
	end,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 1,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "float",
	close_on_exit = true,
	float_opts = {
		border = "rounded",
		width = vim.fn.round(0.9 * vim.o.columns),
		height = vim.fn.round(0.9 * vim.o.lines),
		winblend = 10,
		highlights = { border = "FloatBorder", background = "Normal" },
	},
	on_open = function()
		set("t", "<Esc>", "<C-BSlash><C-n>", { buffer = true })
	end,
})

vim.cmd [[
  if has('nvim')
    let $GIT_EDITOR = "nvim --server $NVIM_SERVER --remote"
  endif
]]
vim.cmd([[autocmd FileType toggleterm nmap <buffer> - +]])
vim.cmd([[autocmd FileType toggleterm nmap <buffer> <space><space> <cmd>ToggleTerm<CR>]])
