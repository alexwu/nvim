local set = require("bombeelu.utils").set

local M = {}

-- FIXME: Some of this will get called multiple times unnecessarily. This might need the project config stuff?
function M.on_attach(client, bufnr)
  if not client.name == "null-ls" and (client.name == "tsserver" or client.server_capabilities.inlayHintProvider) then
    require("inlay-hints").on_attach(client, bufnr)
  end

  if not client.name == "null-ls" and client.server_capabilities.colorProvider then
    require("document-color").buf_attach(bufnr)
  end

  vim.api.nvim_create_augroup("LspDiagnosticsConfig", { clear = true })
  local semanticTokensProviderFull = vim.tbl_get(client, "server_capabilities", "semanticTokensProvider", "full")
  if not client.name == "eslint" and (semanticTokensProviderFull or client.name == "tsserver") then
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      group = "LspDiagnosticsConfig",
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.semantic_tokens_full()
      end,
    })

    -- vim.api.nvim_create_autocmd({ "CursorHold", "ModeChanged", "WinScrolled" }, {
    --   group = "LspDiagnosticsConfig",
    --   buffer = bufnr,
    --   callback = function()
    --     vim.lsp.semantic_tokens.refresh(vim.api.nvim_get_current_buf())
    --   end,
    -- })
    --
    -- vim.api.nvim_create_autocmd({ "WinEnter" }, {
    --   group = "LspDiagnosticsConfig",
    --   buffer = bufnr,
    --   callback = function()
    --     vim.api.nvim_buf_attach(
    --       bufnr,
    --       false,
    --       { on_lines = function(_, _, changedtick, first_line, last_changed_line, last_updated_line) end }
    --     )
    --   end,
    -- })
  end
end

local make_capabilities = function()
  local cap = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

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
