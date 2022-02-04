local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"
local util = lspconfig.util
local root_pattern = util.root_pattern
local lsp_installer = require "nvim-lsp-installer"
local on_attach = require("plugins.lsp.defaults").on_attach
local capabilities = require("plugins.lsp.defaults").capabilities
local null_ls = require "null-ls"
-- require "plugins.lsp.rubocop"

null_ls.setup {
  sources = {
    null_ls.builtins.formatting.rubocop.with {
      command = "bundle",
      args = vim.list_extend(
        { "exec", "rubocop" },
        require("null-ls").builtins.formatting.rubocop._opts.args
      ),
    },
    null_ls.builtins.diagnostics.rubocop.with {
      command = "bundle",
      args = vim.list_extend(
        { "exec", "rubocop" },
        require("null-ls").builtins.diagnostics.rubocop._opts.args
      ),
    },
    null_ls.builtins.formatting.pg_format,
    null_ls.builtins.formatting.prismaFmt,
    null_ls.builtins.code_actions.gitsigns,
  },
}

lsp_installer.settings {
  log_level = vim.log.levels.DEBUG,
}
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

      local ts_utils = require "nvim-lsp-ts-utils"

      ts_utils.setup {
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
      }
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
        executor = require("rust-tools/executors").termopen,
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

  vim.cmd [[ do User LspAttachBuffers ]]
end)

-- lspconfig["rubocop-lsp"].setup {
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }

-- local rubocop = {
--   lintCommand = "bundle exec rubocop --force-exclusion --stdin ${INPUT}",
--   lintStdin = true,
--   lintFormats = { "%f:%l:%c: %m" },
--   lintIgnoreExitCode = true,
--   formatCommand = "bundle exec rubocop -A -f quiet --stderr -s ${INPUT}",
--   formatStdin = true,
-- }
--
-- lspconfig.efm.setup {
--   init_options = {
--     documentFormatting = true,
--     codeAction = true,
--     completion = true,
--     hover = true,
--     documentSymbol = true,
--   },
--   filetypes = { "ruby", "eruby" },
--   root_dir = root_pattern ".rubocop.yml",
--   settings = {
--     rootMarkers = { ".rubocop.yml" },
--     languages = {
--       ruby = { rubocop },
--     },
--   },
--   on_attach = on_attach,
--   capabilities = capabilities,
-- }

lspconfig.sorbet.setup {
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
  root_dir = util.root_pattern "sorbet",
}

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
--
-- require("trouble").setup {}

vim.cmd [[autocmd FileType qf nnoremap <buffer> <silent> <CR> <CR>:cclose<CR>]]
vim.cmd [[autocmd FileType LspInfo,null-ls-info nmap <buffer> q <cmd>quit<cr>]]
