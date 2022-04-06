local M = {}
local on_attach = require("plugins.lsp.defaults").on_attach

function M.on_attach(client, bufnr)
	client.resolved_capabilities.document_formatting = false
	client.resolved_capabilities.document_range_formatting = false

	on_attach(client, bufnr)

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

return M
