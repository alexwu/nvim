local M = {}
local builtin = require("telescope.builtin")
local set = vim.keymap.set

function M.on_attach(_, bufnr)
	local signs = {
		Error = "✘ ",
		Warn = " ",
		Hint = " ",
		Info = " ",
	}

	for type, icon in pairs(signs) do
		local hl = "DiagnosticSign" .. type
		vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
	end

	vim.diagnostic.config({
		virtual_text = {
			severity = { min = vim.diagnostic.severity.ERROR },
		},
		underline = {
			-- severity = { min = vim.diagnostic.severity.ERROR },
		},
		signs = true,
		float = {
			show_header = false,
			source = "always",
		},
		update_in_insert = false,
	})
	vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
		virtual_text = {
			severity = { min = vim.diagnostic.severity.ERROR },
		},
		underline = {
			-- severity = { min = vim.diagnostic.severity.ERROR },
		},
		signs = true,
		float = {
			show_header = false,
			source = "always",
		},
		update_in_insert = false,
	})
	vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
		vim.lsp.handlers.hover,
		{ border = "rounded", focusable = false }
	)
	set("n", "gd", function()
		builtin.lsp_definitions()
		-- vim.lsp.buf.definition()
	end)

	set("n", "gr", function()
		builtin.lsp_references()
		-- vim.lsp.buf.references()
	end)

	set("n", "gi", function()
		builtin.lsp_implementations()
	end)

	-- set("n", "gD", function()
	-- 	vim.lsp.buf.declaration()
	-- end, { silent = true })

	set("n", "K", function()
		vim.lsp.buf.hover()
	end, { silent = true })

	set("n", "L", function()
		vim.diagnostic.open_float(nil, {
			scope = "line",
			show_header = false,
			source = "always",
			focusable = false,
			border = "rounded",
		})
	end, { silent = true })

	set("n", "<Leader>a", function()
		vim.lsp.buf.code_action()
	end, { silent = true })

	set("n", "[d", function()
		vim.lsp.diagnostic.goto_prev()
	end, { silent = true })

	set("n", "]d", function()
		vim.lsp.diagnostic.goto_next()
	end, { silent = true })

	set("n", "<BSlash>y", function()
		vim.lsp.buf.formatting()
	end, { silent = true })

	vim.cmd([[autocmd CursorHold,CursorHoldI * lua require("nvim-lightbulb").update_lightbulb()]])
	vim.cmd([[autocmd CursorHold * lua Show_cursor_diagnostics()]])
end

function Show_cursor_diagnostics()
	vim.diagnostic.open_float(nil, {
		scope = "cursor",
		show_header = false,
		source = "always",
		focusable = false,
		border = "rounded",
	})
end

local capabilities = function()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	return capabilities
end

M.capabilities = capabilities()

return M
