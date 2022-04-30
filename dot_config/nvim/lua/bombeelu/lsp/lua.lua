local lspconfig = require("lspconfig")

local lua = {}

function lua.setup(opts)
	lspconfig.sumneko_lua.setup({
		on_attach = opts.on_attach,
		capabilities = opts.capabilities,
		settings = {
			Lua = {
				diagnostics = { enable = false, globals = { "vim", "use", "use_rocks" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
			},
		},
	})
end

return lua
