return {
  {
    "saecki/crates.nvim",
    cond = function()
      local result = require("bombeelu.utils").root_pattern("Cargo.toml")(vim.uv.cwd() or vim.uv.os_homedir())

      return result
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/nvim-cmp",
      "neovim/nvim-lspconfig",
    },
    opts = function()
      return {
        lsp = {
          enabled = true,
          on_attach = require("plugins.lsp.defaults").on_attach,
          actions = true,
          completion = true,
          hover = true,
        },
      }
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = function()
        return {
          server = {
            on_attach = function(client, bufnr)
              local opts = { noremap = true, silent = true, buffer = bufnr }
              set("n", "<CR>", '<cmd>lua require("tree_climber_rust").init_selection()<CR>', opts)
              set("x", "<CR>", '<cmd>lua require("tree_climber_rust").select_incremental()<CR>', opts)
              set("x", "<BS>", '<cmd>lua require("tree_climber_rust").select_previous()<CR>', opts)
            end,
          },
          default_settings = {
            -- rust-analyzer language server configuration
            ["rust-analyzer"] = {
              cargo = {
                features = "all",
              },
            },
          },
        }
      end
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
  { "adaszko/tree_climber_rust.nvim" },
}
