local defaults = require("plugins.lsp.defaults")
local lspconfig = require("lspconfig")

local lua = {}

function lua.setup(opts)
  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)
  local capabilities = vim.F.if_nil(o.capabilities, defaults.capabilities)

  require("neodev").setup({
    library = {
      vimruntime = true,
      types = true,
      plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim", "neotest", "bu", "nui.nvim", "legendary.nvim" },
    },
    runtime_path = false,
  })

  lspconfig.lua_ls.setup({
    on_attach = on_attach,
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
        semantic = { enable = false },
        diagnostics = { enable = true },
        completion = { autoRequire = false },
        hint = {
          enable = true,
          arrayIndex = "Disable",
        },
      },
    },
  })
end

return lua
