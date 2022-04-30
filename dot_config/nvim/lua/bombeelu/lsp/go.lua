local go = {}

function go.setup(opts)
	require("lspconfig").gopls.setup({
		on_attach = opts.on_attach,
		capabilities = opts.capabilities,
		settings = {
			gopls = {
				experimentalPostfixCompletions = true,
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
			},
		},
		init_options = {
			usePlaceholders = true,
		},
	})
end

return go
