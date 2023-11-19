local M = {}

local methods = vim.lsp.protocol.Methods

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

  if client.supports_method(methods.textDocument_codeLens) then
    legendary.keymap({
      "<leader>cl",
      vim.lsp.codelens.run,
      modes = { "n" },
      opts = { desc = "Run CodeLens", buffer = bufnr },
    })

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
      callback = vim.lsp.codelens.refresh,
    })

    -- Initial CodeLens display.
    vim.lsp.codelens.refresh()
  end
end

local make_capabilities = function()
  local cap = require("cmp_nvim_lsp").default_capabilities()
  local lsp_selection_range = require("lsp-selection-range")

  cap = lsp_selection_range.update_capabilities(cap)

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
