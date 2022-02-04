local tree_width = require("utils").tree_width
local set = vim.keymap.set

require("focus").setup {
  enable = true,
  excluded_filetypes = { "toggleterm" },
  treewidth = tree_width(0.2),
  signcolumn = false,
  width = 120,
}

set("n", "<leader>h", "<cmd>FocusSplitLeft<CR>", { silent = true })
set("n", "<leader>j", "<cmd>FocusSplitDown<CR>", { silent = true })
set("n", "<leader>k", "<cmd>FocusSplitUp<CR>", { silent = true })
set("n", "<leader>l", "<cmd>FocusSplitRight<CR>", { silent = true })
