local Job = require("plenary.job")
-- NOTE: By default, this should probably use whatever is attached to the buffer
local ruby = {}

function root_pattern(...)
  return vim.fs.find({ ... }, { upward = true, stop = vim.loop.os_homedir() })
end

function check_gemfile(gem)
  local root = root_pattern("Gemfile")
  if not root then
    return false
  end

  Job
    :new({
      command = "bundle",
      args = { "info", gem },
      cwd = vim.fs.dirname(root[1]),
      on_exit = function(j, code, signal)
        vim.pretty_print(j:result())
      end,
    })
    :sync()
end

-- check_gemfile("rails")

ruby.config = {
  -- NOTE: Both need this
  root_dir = root_pattern("Gemfile"),
  sorbet = {},
  ruby_lsp = {},

  -- NOTE: This doesn't have an LSP
  rails = {},
  lsp = {
    server = {
      sorbet = { cmd = "bundle exec sorbet", should_attach = root_pattern("sorbet") },
      ruby_lsp = { cmd = "ruby-lsp", should_attach = root_pattern("Gemfile") },
    },
    handlers = {
      completion = { "sorbet", "ruby_lsp" },
      code_action = { "sorbet", "ruby_lsp" },
      declaration = "sorbet",
      definition = "sorbet",
      diagnostics = { "sorbet", "ruby_lsp" },
      formatting = "sorbet",
      hover = { "sorbet" },
      inlay_hints = {},
      implementation = "sorbet",
      references = "sorbet",
      rename = "sorbet",
      semantic_tokens = "ruby_lsp",
    },
  },
}

function ruby.code_action() end
function ruby.definition() end
function ruby.document_highlight() end
function ruby.document_symbol() end
function ruby.format() end
function ruby.hover() end
function ruby.references() end

-- TODO: Figure out how to fallback to treesitter if necessary
function ruby.rename() end
function ruby.workspace_symbol() end

return ruby
