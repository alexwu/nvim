local M = {}

function M.setup(opts)
  require("typescript").setup({
    server = {
      on_attach = function(c, bufnr)
        opts.on_attach(c, bufnr)
      end,
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

      --   settings = {
      --     javascript = {
      --       inlayHints = {
      --         includeInlayEnumMemberValueHints = true,
      --         includeInlayFunctionLikeReturnTypeHints = true,
      --         includeInlayFunctionParameterTypeHints = true,
      --         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      --         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      --         includeInlayPropertyDeclarationTypeHints = true,
      --         includeInlayVariableTypeHints = true,
      --       },
      --     },
      --     typescript = {
      --       inlayHints = {
      --         includeInlayEnumMemberValueHints = true,
      --         includeInlayFunctionLikeReturnTypeHints = true,
      --         includeInlayFunctionParameterTypeHints = true,
      --         includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
      --         includeInlayParameterNameHintsWhenArgumentMatchesName = true,
      --         includeInlayPropertyDeclarationTypeHints = true,
      --         includeInlayVariableTypeHints = true,
      --       },
      --     },
      --   },
    },
  })
end

return M
