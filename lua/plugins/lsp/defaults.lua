local M = {}

function M.on_attach(client, bufnr)
  local legendary = require("legendary")
  -- if not client.name == "null-ls" and client.server_capabilities.inlayHintProvider then
  --   require("inlay-hints").on_attach(client, bufnr)
  -- end

  if not client.name == "null-ls" and client.server_capabilities.colorProvider then
    require("document-color").buf_attach(bufnr)
  end

  vim.api.nvim_create_augroup("LspDiagnosticsBufferConfig", { clear = true })

  legendary.keymap({
    "<Leader>a",
    function()
      vim.lsp.buf.code_action()
    end,
    modes = { "n", "x" },
    opts = { silent = true, desc = "Select a code action", buffer = bufnr },
  })
  -- if not client.name == "eslint" and semanticTokensProviderFull then
  --   vim.api.nvim_create_autocmd({ "BufEnter" }, {
  --     group = "LspDiagnosticsConfig",
  --     buffer = bufnr,
  --     callback = function()
  --       vim.lsp.buf.semantic_tokens_full()
  --     end,
  --   })
  -- end
end

local make_capabilities = function()
  local cap = require("cmp_nvim_lsp").default_capabilities()

  cap.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  cap.textDocument.selectionRange = {
    dynamicRegistration = false,
  }

  cap.textDocument.colorProvider = { dynamicRegistration = false }

  return cap
end

M.capabilities = make_capabilities()

M.handlers = {}

return M
