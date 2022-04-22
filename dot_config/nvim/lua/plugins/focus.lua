local tree_width = require("utils").tree_width

require("focus").setup({
  enable = true,
  excluded_filetypes = { "toggleterm", "DiffviewFiles" },
  treewidth = tree_width(0.2),
  signcolumn = false,
  width = 120,
})
