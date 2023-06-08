local defaults = require("plugins.lsp.defaults")

local M = {}

function M.setup(opts)
  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)
  local capabilities = vim.F.if_nil(o.capabilities, defaults.capabilities)

  require("typescript").setup({
    server = {
      on_attach = on_attach,
      capabilities = capabilities,
      init_options = {
        hostInfo = "neovim",
        preferences = {
          includeCompletionsForImportStatements = true,
          includeInlayParameterNameHints = "none",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = false,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
          importModuleSpecifierPreference = "shortest",
        },
      },
    },
  })
end

return M
