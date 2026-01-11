return {
  {
    "folke/lazydev.nvim",
    enabled = false,
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        "luvit-meta/library",
        { path = "snacks.nvim", words = { "Snacks" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true },
}
