local M = {}

local methods = vim.lsp.protocol.Methods

function M.on_attach(client, bufnr)
  local legendary = require("legendary")

  nvim.create_augroup("LspDiagnosticsBufferConfig", { clear = true })

  if client.supports_method(methods.textDocument_codeLens) then
    local codelens_group = vim.api.nvim_create_augroup("bombeelu/codelens", { clear = false })
    vim.api.nvim_create_autocmd("InsertEnter", {
      group = codelens_group,
      desc = "Disable CodeLens in insert mode",
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.clear(nil, bufnr)
      end,
    })
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      group = codelens_group,
      desc = "Refresh CodeLens",
      buffer = bufnr,
      callback = function()
        vim.lsp.codelens.refresh({ bufnr = bufnr })
      end,
    })

    -- Initial CodeLens display.
    vim.lsp.codelens.refresh({ bufnr = bufnr })
  end
end

local make_capabilities = function()
  local cap = vim.lsp.protocol.make_client_capabilities()
  if package.loaded.cmp_nvim_lsp then
    cap = require("cmp_nvim_lsp").default_capabilities()
  elseif package.loaded.blink then
    cap = require("blink.cmp").get_lsp_capabilities(cap)
  end

  if package.loaded["lsp-selection-range"] then
    cap = require("lsp-selection-range").update_capabilities(cap)
  end

  cap.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }

  -- cap.textDocument.selectionRange = {
  --   dynamicRegistration = false,
  -- }

  cap.textDocument.colorProvider = {
    dynamicRegistration = false,
  }

  return cap
end

M.capabilities = make_capabilities()

M.handlers = {}

return M
