local M = {}
local set = vim.keymap.set
local telescope = require("telescope.builtin")

function M.on_attach(_, _bufnr)
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
		underline = {},
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
		telescope.lsp_definitions()
	end)

	set("n", "gr", function()
		telescope.lsp_references()
	end)

	set("n", "gi", function()
		telescope.lsp_implementations()
	end)

	set("n", "g-", function()
		telescope.lsp_document_symbols()
	end)

	set("n", "gD", function()
		vim.lsp.buf.type_definition()
	end, { silent = true })

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
		require("code_action_menu").open_code_action_menu()
	end, { silent = true })

	set("n", "ga", function()
		require("code_action_menu").open_code_action_menu()
	end, { silent = true })

	set("n", "[d", function()
		vim.diagnostic.goto_prev()
	end, { silent = true })

	set("n", "]d", function()
		vim.diagnostic.goto_next()
	end, { silent = true })

	-- set("n", "<BSlash>y", function()
	-- 	vim.lsp.buf.formatting()
	-- end, { silent = true })
	--
	-- set({ "n", "i" }, "<F8>", function()
	-- 	vim.lsp.buf.formatting()
	-- end, { silent = true })
	--
	set("v", "<F8>", function()
		vim.lsp.buf.range_formatting()
	end, { silent = true })

	vim.api.nvim_create_augroup("LspDiagnosticsConfig", { clear = true })
	vim.api.nvim_create_autocmd("CursorHold", {
		pattern = "*",
		group = "LspDiagnosticsConfig",
		callback = function()
			vim.diagnostic.open_float(nil, {
				scope = "cursor",
				show_header = false,
				source = "always",
				focusable = false,
				border = "rounded",
			})
		end,
	})
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		pattern = "*",
		group = "LspDiagnosticsConfig",
		callback = function()
			require("nvim-lightbulb").update_lightbulb()
		end,
	})
end

local capabilities = function()
	local cmp_capabilities = vim.lsp.protocol.make_client_capabilities()
	cmp_capabilities = require("cmp_nvim_lsp").update_capabilities(cmp_capabilities)
	return cmp_capabilities
end

M.capabilities = capabilities()

return M
