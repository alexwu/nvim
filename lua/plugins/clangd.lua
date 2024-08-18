return {
  {
    "p00f/clangd_extensions.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "aznhe21/actions-preview.nvim",
      "neovim/nvim-lspconfig",
      "aznhe21/actions-preview.nvim",
      "camilledejoye/nvim-lsp-selection-range",
    },
    cond = function()
      local result = require("bombeelu.utils").root_pattern(
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac"
      )(vim.uv.cwd() or vim.uv.os_homedir())

      return result
    end,
    opts = function()
      return {
        server = {
          on_attach = require("plugins.lsp.defaults").on_attach,
        },
        extensions = {
          autoSetHints = false,
        },
      }
    end,
  },
}
