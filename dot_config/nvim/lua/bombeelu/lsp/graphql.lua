local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern

local graphql = {}

function graphql.setup(opts)
	lspconfig.graphql.setup({
		on_attach = opts.on_attach,
		capabilities = opts.capabilities,
		root_dir = root_pattern(".git", "graphql.config.ts"),
	})
end

return graphql
