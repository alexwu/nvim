return {
  { "rafamadriz/friendly-snippets" },
  {
    "garymjr/nvim-snippets",
    event = "VeryLazy",
    opts = {
      friendly_snippets = true,
      create_cmp_source = false,
    },
  },
  {
    "chrisgrieser/nvim-scissors",
    event = "VeryLazy",
    dependencies = { "garymjr/nvim-snippets" },
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
    },
  },
}
