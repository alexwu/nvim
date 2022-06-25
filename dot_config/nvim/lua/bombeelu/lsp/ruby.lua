local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")
local util = require("lspconfig.util")

local ruby = {}

function ruby.setup(opts)
  if not configs.ruby_lsp then
    local enabled_features = {
      "documentHighlights",
      "documentSymbols",
      "foldingRanges",
      "selectionRanges",
      "semanticHighlighting",
      "formatting",
      "codeActions",
    }

    configs.ruby_lsp = {
      default_config = {
        cmd = { "ruby-lsp" },
        filetypes = { "ruby" },
        root_dir = util.root_pattern("Gemfile", ".git"),
        init_options = {
          enabledFeatures = enabled_features,
        },
        settings = {},
      },
      commands = {
        FormatRuby = {
          function()
            vim.lsp.buf.format({
              name = "ruby_lsp",
              async = true,
            })
          end,
          description = "Format using ruby-lsp",
        },
      },
    }
  end

  opts.capabilities["workspace"]["semanticTokens"] = { refreshSupport = true }

  opts.capabilities.textDocument.semanticTokens = {
    semanticTokens = {
      dynamicRegistration = false,
      tokenTypes = {
        "namespace",
        "type",
        "class",
        "enum",
        "interface",
        "struct",
        "typeParameter",
        "parameter",
        "variable",
        "property",
        "enumMember",
        "event",
        "function",
        "method",
        "macro",
        "keyword",
        "modifier",
        "comment",
        "string",
        "number",
        "regexp",
        "operator",
      },
      tokenModifiers = {
        "declaration",
        "definition",
        "readonly",
        "static",
        "deprecated",
        "abstract",
        "async",
        "modification",
        "documentation",
        "defaultLibrary",
      },
      formats = { "relative" },
      requests = {
        -- TODO(smolck): Add support for this
        -- range = true;
        full = { delta = false },
      },

      overlappingTokenSupport = true,
      -- TODO(theHamsta): Add support for this
      multilineTokenSupport = false,
    },
  }

  lspconfig.ruby_lsp.setup(opts)
end

return ruby
