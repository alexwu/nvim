return {
  {
    "yioneko/nvim-vtsls",
    config = function()
      require("lspconfig.configs").vtsls = require("vtsls").lspconfig
    end,
    keys = {
      {
        "gD",
        function()
          require("vtsls").commands.goto_source_definition(0)
        end,
        desc = "Goto Source Definition",
      },
      {
        "<leader>co",
        function()
          require("vtsls").commands.organize_imports(0)
        end,
        desc = "Organize Imports",
      },
      {
        "<leader>cM",
        function()
          require("vtsls").commands.add_missing_imports(0)
        end,
        desc = "Add missing imports",
      },
      {
        "<leader>cu",
        function()
          require("vtsls").commands.remove_unused_imports(0)
        end,
        desc = "Remove unused imports",
      },
      {
        "<leader>cU",
        function()
          require("vtsls").commands.remove_unused(0)
        end,
        desc = "Remove unused",
      },
    },
  },
  {
    "dmmulroy/tsc.nvim",
    config = true,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    dependencies = { "neovim/nvim-lspconfig", "yioneko/nvim-vtsls" },
    cond = function()
      return not vim.g.vscode
    end,
    opts = {},
    config = true,
  },
}
