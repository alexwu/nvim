local set = vim.keymap.set

vim.g.kitty_navigator_no_mappings = 1

set("n", "<A-h>", "<cmd>KittyNavigateLeft<cr>")
set("n", "<A-l>", "<cmd>KittyNavigateRight<cr>")
set("n", "<A-j>", "<cmd>KittyNavigateDown<cr>")
set("n", "<A-k>", "<cmd>KittyNavigateUp<cr>")

set("n", "<C-Left>", "<cmd>KittyNavigateLeft<cr>")
set("n", "<C-Right>", "<cmd>KittyNavigateRight<cr>")
set("n", "<C-Down>", "<cmd>KittyNavigateDown<cr>")
set("n", "<C-Up>", "<cmd>KittyNavigateUp<cr>")
