return {
  {
    "suketa/nvim-dap-ruby",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
    },
    opts = {},
  },
  {
    "nvim-neotest/neotest",
    -- ft = { "ruby" },
    dependencies = {
      { "alexwu/neotest-rspec", dev = true, branch = "custom-test-names" },
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          rspec_cmd = function(position_type)
            if position_type == "test" then
              return vim
                .iter({
                  "bundle",
                  "exec",
                  "rspec",
                  "--fail-fast",
                })
                :flatten()
                :totable()
            else
              return vim
                .iter({
                  "bundle",
                  "exec",
                  "rspec",
                })
                :flatten()
                :totable()
            end
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
