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
      -- "semanticHighlighting", TODO: Add when support is added to neovim
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

  lspconfig.ruby_lsp.setup(opts)
end

return ruby
