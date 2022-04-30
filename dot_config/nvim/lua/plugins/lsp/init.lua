local lsp = require("bombeelu.lsp")
local lsp_installer = require("nvim-lsp-installer")
local on_attach = require("plugins.lsp.defaults").on_attach
local capabilities = require("plugins.lsp.defaults").capabilities
local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

lsp_installer.setup({
	ensure_installed = { "sumneko_lua", "tsserver", "eslint", "jsonls", "rust_analyzer", "graphql" },
})

lsp.eslint.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.go.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.graphql.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.json.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.lua.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.rust.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.sorbet.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.teal.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.typescript.setup({ on_attach = on_attach, capabilities = capabilities })

augroup("LspCustom", { clear = true })

autocmd("FileType", {
	pattern = "qf",
	group = "LspCustom",
	callback = function()
		set("n", "<CR>", "<CR>:cclose<CR>")
	end,
})

autocmd("FileType", {
	pattern = { "LspInfo", "null-ls-info" },
	group = "LspCustom",
	callback = function()
		set("n", "q", "<cmd>quit<cr>")
	end,
})
