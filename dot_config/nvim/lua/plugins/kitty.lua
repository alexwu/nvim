local set = vim.keymap.set

vim.g.kitty_navigator_no_mappings = 1

set("n", "<A-h>", "<cmd>KittyNavigateLeft<cr>")
set("n", "<A-l>", "<cmd>KittyNavigateRight<cr>")
set("n", "<A-j>", "<cmd>KittyNavigateDown<cr>")
set("n", "<A-k>", "<cmd>KittyNavigateUp<cr>")

set("n", "<A-Left>", "<cmd>KittyNavigateLeft<cr>")
set("n", "<A-Right>", "<cmd>KittyNavigateRight<cr>")
set("n", "<A-Down>", "<cmd>KittyNavigateDown<cr>")
set("n", "<A-Up>", "<cmd>KittyNavigateUp<cr>")
