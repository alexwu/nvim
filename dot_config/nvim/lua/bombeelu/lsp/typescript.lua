local lspconfig = require("lspconfig")
local M = {}

local function build_on_attach(default)
	return function(client, bufnr)
		default(client, bufnr)

		local ts_utils = require("nvim-lsp-ts-utils")

		ts_utils.setup({
			disable_commands = false,
			eslint_enable_code_actions = false,
			enable_import_on_completion = true,
			import_on_completion_timeout = 5000,
			eslint_enable_diagnostics = false,
			eslint_bin = "eslint_d",
			eslint_opts = { diagnostics_format = "#{m} [#{c}]" },
			enable_formatting = false,
			formatter = "eslint_d",
			filter_out_diagnostics_by_code = { 80001 },
			auto_inlay_hints = true,
			inlay_hints_highlight = "Comment",
		})
	end
end

function M.setup(opts)
	lspconfig.tsserver.setup({
		on_attach = build_on_attach(opts.on_attach),
		capabilities = opts.capabilities,
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
		filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
	})
end

return M
