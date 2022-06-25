local lspconfig = require("lspconfig")

local lua = {}

function lua.setup(opts)
  local luadev = require("lua-dev").setup({
    lspconfig = {
      on_attach = opts.on_attach,
      capabilities = opts.capabilities,
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
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    },
  })

  lspconfig.sumneko_lua.setup(luadev)
end

return lua
