local M = {}

function M.setup(opts)
	require("rust-tools").setup({
		tools = {
			executor = require("rust-tools/executors").toggleterm,
			diagnostics = {
				enable = true,
				disabled = { "unresolved-proc-macro" },
				enableExperimental = true,
			},
		},
		server = {
			on_attach = opts.on_attach,
			capabilities = opts.capabilities,
			settings = {
				["rust-analyzer"] = {
					diagnostics = {
						enable = true,
						disabled = { "unresolved-proc-macro" },
						enableExperimental = true,
					},
					checkOnSave = {
						command = "clippy",
					},
				},
			},
		},
	})
end

return M
