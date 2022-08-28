local ft = require("plenary.filetype")
local defaults = require("plugins.lsp.defaults")

local M = {}

function M.setup(opts)
  local fts = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
  if not vim.tbl_contains(fts, ft.detect(vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf()))) then
    return
  end

  local o = vim.F.if_nil(opts, {})
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)

  require("typescript").setup({
    server = {
      on_attach = on_attach,
      init_options = {
        hostInfo = "neovim",
        preferences = {
          includeCompletionsForImportStatements = true,
          includeInlayParameterNameHints = "none",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
  })
end

return M
