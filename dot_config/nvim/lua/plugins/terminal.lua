local Terminal = require("toggleterm.terminal").Terminal
local set = vim.keymap.set

local rails_console = Terminal:new({
	cmd = "bundle exec rails console",
	direction = "float",
	float_opts = {
		border = "rounded",
		width = vim.fn.round(0.9 * vim.o.columns),
		height = vim.fn.round(0.9 * vim.o.lines),
		winblend = 0,
		highlights = { border = "FloatBorder", background = "Normal" },
	},
})

local rails_runner = Terminal:new({
	cmd = "bundle exec rails runner " .. vim.fn.expand("%"),
	direction = "float",
	float_opts = {
		border = "rounded",
		width = vim.fn.round(0.9 * vim.o.columns),
		height = vim.fn.round(0.9 * vim.o.lines),
		winblend = 0,
		highlights = { border = "FloatBorder", background = "Normal" },
	},
	close_on_exit = false,
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
})

local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

local lazygit_toggle = function()
	lazygit:toggle()
end

set("n", "<leader>g", function()
	lazygit_toggle()
end, { noremap = true, silent = true })

function Rails_console()
	rails_console:toggle()
end

_G.runner = function()
	rails_runner:toggle()
end

require("toggleterm").setup({
	size = function(term)
		if term.direction == "horizontal" then
			return 15
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.8
		end
	end,
	open_mapping = [[<A-Bslash>]],
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
})

vim.cmd([[
  if has('nvim') && executable('nvr')
    let $GIT_EDITOR = "nvr -cc split --remote-wait +'set bufhidden=wipe'"
  endif
]])

vim.cmd([[autocmd FileType toggleterm nmap <buffer> - +]])
vim.cmd([[autocmd FileType toggleterm nmap <buffer> <space><space> <cmd>ToggleTerm<CR>]])
vim.cmd([[autocmd FileType toggleterm tmap <buffer> <esc> <C-\><C-n>]])
vim.cmd([[command! -nargs=0 RConsole :lua Rails_console()<CR>]])
vim.cmd([[command! -nargs=0 RRunner :lua runner()<CR>]])
