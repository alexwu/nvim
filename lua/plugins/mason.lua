return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      -- automatic_enable = false,
      automatic_enable = {
        exclude = {
          "harper-ls",
          "harper_ls",
          "lua_ls",
          "lua-language-server",
        },
      },
    },
  },
}
