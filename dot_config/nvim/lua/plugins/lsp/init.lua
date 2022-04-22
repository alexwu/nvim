local lspconfig = require("lspconfig")
local root_pattern = lspconfig.util.root_pattern
local lsp_installer = require("nvim-lsp-installer")
local typescript = require("plugins.lsp.typescript")
local on_attach = require("plugins.lsp.defaults").on_attach
local capabilities = require("plugins.lsp.defaults").capabilities
local set = vim.keymap.set
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- TODO: Make a global callback thing that lets me select the best formatter for the moment
local formatting_callback = function(client, bufnr)
	map({ "n" }, { "<leader>y", "<F8>" }, function()
		local params = vim.lsp.util.make_formatting_params({})
		client.request("textDocument/formatting", params, nil, bufnr)
	end, { buffer = bufnr })
end

lsp_installer.on_server_ready(function(server)
	local opts = { on_attach = on_attach, capabilities = capabilities }

	if server.name == "sumneko_lua" then
		opts.settings = {
			Lua = {
				diagnostics = { enable = false, globals = { "vim", "use", "use_rocks" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
			},
		}
	end

	if server.name == "tsserver" then
		opts.on_attach = typescript.on_attach
		opts.init_options = {
			hostInfo = "neovim",
			preferences = {
				includeCompletionsForImportStatements = true,
				includeInlayParameterNameHints = "none",
				includeInlayParameterNameHintsWhenArgumentMatchesName = false,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayVariableTypeHints = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayEnumMemberValueHints = true,
			},
		}
		opts.settings = {
			flags = {
				debounce_text_changes = 150,
			},
		}
		opts.filetypes = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" }
	end

	if server.name == "eslint" then
		opts.settings = {
			format = { enable = false },
			rulesCustomizations = { { rule = "*", severity = "warn" } },
		}
	end

	if server.name == "graphql" then
		opts.root_dir = root_pattern(".git", "graphql.config.ts")
	end

	if server.name == "jsonls" then
		opts.settings = {
			json = {
				schemas = require("schemastore").json.schemas(),
			},
		}
	end

	if server.name == "rust_analyzer" then
		local rustopts = {
			tools = {
				autoSetHints = true,
				hover_with_actions = true,
				executor = require("rust-tools/executors").toggleterm,
				runnables = {
					use_telescope = true,
				},
				debuggables = {
					use_telescope = true,
				},
				inlay_hints = {
					only_current_line = false,
					only_current_line_autocmd = "CursorHold",
					show_parameter_hints = true,
					parameter_hints_prefix = "<- ",
					other_hints_prefix = "=> ",
					max_len_align = false,
					max_len_align_padding = 1,
					right_align = false,
					right_align_padding = 7,
					highlight = "Comment",
				},
				hover_actions = {
					border = {
						{ "╭", "FloatBorder" },
						{ "─", "FloatBorder" },
						{ "╮", "FloatBorder" },
						{ "│", "FloatBorder" },
						{ "╯", "FloatBorder" },
						{ "─", "FloatBorder" },
						{ "╰", "FloatBorder" },
						{ "│", "FloatBorder" },
					},
					auto_focus = false,
				},
				diagnostics = {
					enable = true,
					disabled = { "unresolved-proc-macro" },
					enableExperimental = true,
				},
			},
			server = vim.tbl_deep_extend("force", server:get_default_options(), opts, {
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
			}),
		}
		opts.on_attach = function(client, bufnr)
			-- formatting_callback(client, bufnr)
			on_attach(client, bufnr)
		end

		require("rust-tools").setup(rustopts)
	end

	if server.name == "gopls" then
		capabilities = capabilities
		opts.settings = {
			gopls = {
				experimentalPostfixCompletions = true,
				analyses = {
					unusedparams = true,
					shadow = true,
				},
				staticcheck = true,
			},
		}
		opts.init_options = {
			usePlaceholders = true,
		}
	end

	if server.name == "rust_analyzer" then
		server:attach_buffers()
	else
		server:setup(opts)
	end

	vim.api.nvim_exec_autocmds("User LspAttachBuffers", { modeline = false })
end)

lspconfig.sorbet.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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
