if vim.g.goneovim then
  return
end

require("indent_blankline").setup({
  use_treesitter = true,
  show_current_context = true,
  show_current_context_start = false,
  context_highlight = "Label",
  show_first_indent_level = false,
  buftype_exclude = { "help", "fzf", "lspinfo", "NvimTree", "nofile" },
  filetype_exclude = { "help", "fzf", "lspinfo", "NvimTree", "windline" },
  char = "▏",
})
