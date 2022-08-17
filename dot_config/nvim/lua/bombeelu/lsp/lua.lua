local lspconfig = require("lspconfig")
local ih = require("inlay-hints")

local lua = {}

function lua.setup(opts)
  local luadev = require("lua-dev").setup({
    library = {
      vimruntime = true,
      types = true,
      plugins = true,
    },
    runtime_path = false,
    lspconfig = {
      on_attach = function(c, b)
        opts.on_attach(c, b)
      end,
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
