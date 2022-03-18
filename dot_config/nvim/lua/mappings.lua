local keymap = vim.keymap
local set = keymap.set

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

-- set("n", "t", "gt")
-- set("n", "T", "gT")
set("n", "tt", "<cmd>tabnew<CR>")
set("n", "tq", "<cmd>tabclose<CR>")
set("n", "]t", "gt")
set("n", "[T", "gT")
set("n", "Q", "<cmd>close<CR>")

set("n", "<A-o>", "o<esc>")
set("n", "<A-O>", "O<esc>")

vim.cmd([[autocmd FileType qf nnoremap <buffer> <silent> <ESC> :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> q :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> gd <C-]>]])
