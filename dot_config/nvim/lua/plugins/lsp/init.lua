local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local capabilities = require("plugins.lsp.defaults").capabilities
local ex = require("bombeelu.utils").ex
local lazy = require("bombeelu.utils").lazy
local lsp = require("bombeelu.lsp")
local lsp_installer = require("nvim-lsp-installer")
local nvim = require("nvim")
local on_attach = require("plugins.lsp.defaults").on_attach
local set = vim.keymap.set

lsp_installer.setup({
	ensure_installed = { "sumneko_lua", "tsserver", "eslint", "jsonls", "rust_analyzer", "graphql", "gopls" },
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
		set("n", "<CR>", "<CR>" .. ex("cclose"), { buffer = true })
	end,
})

autocmd("FileType", {
	pattern = { "LspInfo", "null-ls-info" },
	group = "LspCustom",
	callback = function()
		set("n", "q", lazy(nvim.ex.quit), { buffer = true })
	end,
})
