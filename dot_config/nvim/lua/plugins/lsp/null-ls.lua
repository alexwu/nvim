local null_ls = require("null-ls")
local on_attach = require("plugins.lsp.defaults").on_attach

local M = {}

M.setup = function(opts)
  opts = opts or {}

  local formatting_callback = function(client, bufnr)
    map({ "n" }, { "<leader>y", "<F8>" }, function()
      local params = vim.lsp.util.make_formatting_params({})
      client.request("textDocument/formatting", params, nil, bufnr)
    end, { buffer = bufnr })
  end

  null_ls.setup({
    sources = {
      null_ls.builtins.formatting.rubocop.with({
        command = "bundle",
        args = vim.list_extend({ "exec", "rubocop" }, require("null-ls").builtins.formatting.rubocop._opts.args),
      }),
      null_ls.builtins.diagnostics.rubocop.with({
        command = "bundle",
        args = vim.list_extend({ "exec", "rubocop" }, require("null-ls").builtins.diagnostics.rubocop._opts.args),
      }),
      null_ls.builtins.formatting.pg_format,
      null_ls.builtins.formatting.prismaFmt,
      null_ls.builtins.formatting.black,
      null_ls.builtins.formatting.prettier,
      null_ls.builtins.diagnostics.zsh,
      null_ls.builtins.diagnostics.selene.with({
        condition = function(utils)
          return utils.root_has_file({ "selene.toml" })
        end,
      }),
      null_ls.builtins.formatting.stylua,
    },
    on_attach = function(client, bufnr)
      -- formatting_callback(client, bufnr)
      on_attach(client, bufnr)
    end,
  })
end

return M
