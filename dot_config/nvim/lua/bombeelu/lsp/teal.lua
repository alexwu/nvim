local lspconfig = require("lspconfig")

local teal = {}

function teal.setup(opts)
	lspconfig.teal_ls.setup({ on_attach = opts.on_attach, capabilities = opts.capabilities })
end

return teal
