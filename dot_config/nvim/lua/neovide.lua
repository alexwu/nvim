vim.g.neovide_transparency = 0.95
vim.g.neovide_input_use_logo = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_remember_window_size = true

set({ "n", "x" }, "<D-v>", [["*p]], { desc = "Paste from system clipboard" })
set({ "i", "c" }, "<D-v>", [[<C-r>*]], { desc = "Paste from system clipboard" })

set({ "n", "x" }, "<D-c>", [["*y]], { desc = "Copy from system clipboard" })
