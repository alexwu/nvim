local M = {}

function M.on_attach(client, bufnr)
  local legendary = require("legendary")

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
