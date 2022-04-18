local set = vim.keymap.set
local api = vim.api

vim.g.mapleader = " "

set("n", "j", "gj")
set("n", "k", "gk")

set({ "x" }, "<C-j>", "5gj")
set({ "x" }, "<C-k>", "5gk")
set({ "x" }, "<C-h>", "5h")
set({ "x" }, "<C-l>", "5l")

set("i", "<C-j>", "<Down>")
set("i", "<C-k>", "<Up>")
set("i", "<C-h>", "<Left>")
set("i", "<C-l>", "<Right>")

set("n", "<ESC>", "<cmd>noh<CR>")
set("x", "<F2>", '"*y')
set("n", "<A-BS>", "db")
set("i", "<A-BS>", "<C-W>")

set("n", "tt", "<cmd>tabnew<CR>")
set("n", "tq", "<cmd>tabclose<CR>")
set("n", "]t", "gt")
set("n", "[T", "gT")
set("n", "Q", function()
	api.nvim_win_close(0, false)
end)

set("n", "<A-o>", "o<esc>")
set("n", "<A-O>", function()
	local pos = api.nvim_win_get_cursor(0)
	local line = pos[1] - 1
	api.nvim_buf_set_lines(0, line, line, true, { "" })
	-- api.nvim_put({ line }, "", false, true)
end)

-- set("n", "<A-O>", "O<esc>")

vim.cmd([[autocmd FileType qf nnoremap <buffer> <silent> <ESC> :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> q :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> gd <C-]>]])
