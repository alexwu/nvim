return {
  {
    "p00f/clangd_extensions.nvim",
    lazy = true,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    init = function()
      local loaded = false
      local function check()
        local result = require("bombeelu.utils").root_pattern(
          ".clangd",
          ".clang-tidy",
          ".clang-format",
          "compile_commands.json",
          "compile_flags.txt",
          "configure.ac"
        )(vim.uv.cwd() or vim.uv.os_homedir())

        if result then
          require("lazy").load({ plugins = { "clangd_extensions.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = require("bu").nvim.augroup("clangd.custom"),
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
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
