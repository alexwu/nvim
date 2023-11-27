if vim.g.goneovim then
  return
end

return {
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      scope = {
        enabled = true,
        show_start = false,
      },
      exclude = { filetypes = { "dashboard" } },
    },
    event = "VeryLazy",
  },
  -- {
  --   "lukas-reineke/indent-blankline.nvim",
  --   event = "VeryLazy",
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   config = function()
  --     require("indent_blankline").setup({
  --       use_treesitter = true,
  --       show_current_context = true,
  --       show_current_context_start = false,
  --       context_highlight = "Label",
  --       show_first_indent_level = false,
  --       buftype_exclude = { "help", "fzf", "lspinfo", "NvimTree", "nofile" },
  --       filetype_exclude = { "help", "fzf", "lspinfo", "NvimTree", "windline" },
  --       char = "▏",
  --     })
  --   end,
  -- },
}
