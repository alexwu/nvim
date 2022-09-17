local defaults = require("plugins.lsp.defaults")
local lspconfig = require("lspconfig")
local ih = require("inlay-hints")

local lua = {}

function lua.setup(opts)
  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)
  local capabilities = vim.F.if_nil(o.capabilities, defaults.capabilities)

  local luadev = require("lua-dev").setup({
    library = {
      vimruntime = true,
      types = true,
      plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim", "neotest" },
    },
    runtime_path = false,
    lspconfig = {
      on_attach = function(c, b)
        on_attach(c, b)
      end,
      capabilities = capabilities,
      root_dir = function(fname)
        local root_pattern = lspconfig.util.root_pattern(".git", "*.rockspec")(fname)

        if fname == vim.loop.os_homedir() then
          return nil
        end

        return root_pattern or fname
      end,
      settings = {
        Lua = {
          semantic = { enable = true },
          diagnostics = { enable = false },
          completion = { autoRequire = false },
          hint = {
            enable = true,
          },
        },
      },
    },
  })

  lspconfig.sumneko_lua.setup(luadev)
end

return lua
