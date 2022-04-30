local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

local sorbet = {}

function sorbet.setup(opts)
	lspconfig.sorbet.setup({
		on_attach = opts.on_attach,
		capabilities = opts.capabilities,
		filetypes = { "ruby" },
		cmd = {
			"bundle",
			"exec",
			"srb",
			"tc",
			"--lsp",
			"--enable-all-beta-lsp-features",
		},
		root_dir = root_pattern("sorbet"),
	})
end

return sorbet
