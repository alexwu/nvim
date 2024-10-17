return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "alexwu/neotest-rspec",
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function()
            return vim
              .iter({
                "bundle",
                "exec",
                "rspec",
              })
              :flatten()
              :totable()
          end,
        },
        -- ["ruby_lsp.neotest"] = {},
      },
    },
  },
  {
    "alexwu/ruby-lsp.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    dev = true,
    opts = function()
      return {
        capabilities = require("plugins.lsp.defaults").capabilities,
        on_attach = require("plugins.lsp.defaults").on_attach,
      }
    end,
    config = true,
    cond = function()
      return not vim.g.vscode
    end,
  },
}
