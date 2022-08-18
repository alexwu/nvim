local set = require("bombeelu.utils").set
local ih = require("inlay-hints")

local M = {}

-- FIXME: Some of this will get called multiple times unnecessarily. This might need the project config stuff?
function M.on_attach(client, bufnr)
  set("n", "<Leader>a", function()
    require("code_action_menu").open_code_action_menu()
  end, { silent = true, buffer = true, desc = "Select a code action" })

  set("v", "<Leader>a", function()
    vim.lsp.buf.range_code_action()
  end, { silent = true, buffer = true, desc = "Select a code action for the selected visual range" })

  vim.api.nvim_create_augroup("LspDiagnosticsConfig", { clear = true })

  if client.name == "tsserver" or client.server_capabilities.inlayHintProvider then
    ih.on_attach(client, bufnr)
  end

  if client.server_capabilities.colorProvider then
    require("document-color").buf_attach(bufnr)
  end

  -- TODO: Renable this when it's stable
  if client.server_capabilities.semanticTokensProvider then
    --   vim.api.nvim_create_autocmd({ "BufEnter" }, {
    --     group = "LspDiagnosticsConfig",
    --     buffer = bufnr,
    --     callback = function()
    --       vim.lsp.buf.semantic_tokens_full()
    --     end,
    --   })
    --
    --   vim.api.nvim_create_autocmd({ "CursorHold", "ModeChanged", "WinScrolled" }, {
    --     group = "LspDiagnosticsConfig",
    --     buffer = bufnr,
    --     callback = function()
    --       vim.lsp.semantic_tokens.refresh(vim.api.nvim_get_current_buf())
    --     end,
    --   })
    --
    --   vim.api.nvim_create_autocmd({ "WinEnter" }, {
    --     group = "LspDiagnosticsConfig",
    --     buffer = bufnr,
    --     callback = function()
    --       vim.api.nvim_buf_attach(
    --         bufnr,
    --         false,
    --         { on_lines = function(_, _, changedtick, first_line, last_changed_line, last_updated_line) end }
    --       )
    --     end,
    --   })
  end

  vim.api.nvim_create_autocmd("CursorHold", {
    group = "LspDiagnosticsConfig",
    buffer = bufnr,
    callback = M.smart_hover,
  })

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    group = "LspDiagnosticsConfig",
    buffer = bufnr,
    callback = function()
      require("nvim-lightbulb").update_lightbulb({ ignore = { "null-ls" } })
    end,
  })
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

  cap.textDocument.colorProvider = true

  return cap
end

function M.smart_hover()
  if vim.diagnostic.config().virtual_lines then
    return
  end

  vim.diagnostic.open_float(nil, {
    scope = "cursor",
    show_header = false,
    source = "always",
    focusable = false,
    border = "rounded",
  })
end

M.capabilities = make_capabilities()

M.handlers = {}

return M
