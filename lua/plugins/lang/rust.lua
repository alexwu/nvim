return {
  {
    "saecki/crates.nvim",
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local result = vim.fs.root(0, { "Cargo.toml" })

        if result then
          require("lazy").load({ plugins = { "crates.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = require("bu").nvim.augroup("crates.custom"),
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      -- "hrsh7th/cmp-nvim-lsp",
      -- "iguanacucumber/mag-nvim-lsp",
      -- "iguanacucumber/magazine.nvim",
      -- "hrsh7th/nvim-cmp",
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
  {
    "nvim-neotest/neotest",
    ft = { "rust" },
    dependencies = {
      "mrcjkb/rustaceanvim",
    },
    opts = {
      adapters = {
        ["rustaceanvim.neotest"] = {},
      },
    },
  },
}
