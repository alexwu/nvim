local lspconfig = require("lspconfig")
local util = lspconfig.util
local root_pattern = util.root_pattern
local lsp_installer = require("nvim-lsp-installer")
local on_attach = require("plugins.lsp.defaults").on_attach
local capabilities = require("plugins.lsp.defaults").capabilities
local null_ls = require("plugins.lsp.null-ls")
local set = vim.keymap.set

lsp_installer.settings({
	log_level = vim.log.levels.DEBUG,
})

lsp_installer.on_server_ready(function(server)
	local opts = { on_attach = on_attach, capabilities = capabilities }

	if server.name == "sumneko_lua" then
		opts.settings = {
			Lua = {
				diagnostics = { globals = { "vim", "use", "use_rocks" } },
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
				},
			},
		}
	end

	if server.name == "tsserver" then
		opts.on_attach = function(client, bufnr)
			client.resolved_capabilities.document_formatting = false
			client.resolved_capabilities.document_range_formatting = false

			on_attach(client, bufnr)

			local ts_utils = require("nvim-lsp-ts-utils")

			ts_utils.setup({
				disable_commands = false,
				eslint_enable_code_actions = false,
				enable_import_on_completion = true,
				import_on_completion_timeout = 5000,
				eslint_enable_diagnostics = false,
				eslint_bin = "eslint_d",
				eslint_opts = { diagnostics_format = "#{m} [#{c}]" },
				enable_formatting = false,
				formatter = "eslint_d",
				filter_out_diagnostics_by_code = { 80001 },
				auto_inlay_hints = true,
				inlay_hints_highlight = "Comment",
			})
		end

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
		opts.on_attach = function(client, bufnr)
			client.resolved_capabilities.document_formatting = true
			on_attach(client, bufnr)
		end
		opts.settings = {
			format = { enable = true },
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

		require("rust-tools").setup(rustopts)
	end

	if server.name == "sqls" then
		opts.settings = {
			sqls = {
				connections = {
					{
						driver = "postgresql",
						dataSourceName = "host=127.0.0.1 port=5432 user=jamesbombeelu  dbname=sheikah-slate_development sslmode=disable",
					},
				},
			},
		}
	end

	if server.name == "rust_analyzer" then
		server:attach_buffers()
	else
		server:setup(opts)
	end

	vim.cmd([[ do User LspAttachBuffers ]])
end)

null_ls.setup()

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
	root_dir = util.root_pattern("sorbet"),
})

-- if not configs["rubocop-lsp"] then
--   configs["rubocop-lsp"] = {
--     default_config = {
--       cmd = { "rubocop-lsp" },
--       filetypes = { "ruby" },
--       root_dir = util.root_pattern(".rubocop.yml", "Gemfile"),
--     },
--   }
-- end
--
-- lspconfig["rubocop-lsp"].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }

vim.api.nvim_create_autocmd({
	event = "FileType",
	pattern = "qf",
	callback = function()
		set("n", "<CR>", "<CR>:cclose<CR>")
	end,
})

vim.api.nvim_create_autocmd({
	event = "FileType",
	pattern = { "LspInfo, null-ls-info" },
	callback = function()
		set("n", "q", "<cmd>quit<cr>")
	end,
})
