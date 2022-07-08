local telescope = require("telescope.builtin")
local lazy = require("bombeelu.utils").lazy
local set = require("bombeelu.utils").set
local navic = require("nvim-navic")

local M = {}

-- FIXME: Some of this will get called multiple times unnecessarily. This might need the project config stuff?
function M.on_attach(client, bufnr)
  vim.pretty_print(client.server_capabilities.documentSymbolProvider)
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  local signs = {
    Error = "✘ ",
    Warn = " ",
    Hint = " ",
    Info = " ",
  }

  for name, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. name
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
  end

  vim.diagnostic.config({
    virtual_text = {
      severity = { min = vim.diagnostic.severity.ERROR },
    },
    underline = {},
    signs = true,
    float = {
      show_header = false,
      source = "always",
    },
    update_in_insert = false,
  })

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", focusable = false })

  set("n", "gd", lazy(telescope.lsp_definitions), { buffer = true, desc = "Go to definition" })
  set("n", "gr", lazy(telescope.lsp_references), { buffer = true, desc = "Go to references" })
  set("n", "gi", lazy(telescope.lsp_implementations), { buffer = true, desc = "Go to implementation" })
  set("n", "g-", lazy(telescope.lsp_document_symbols), { buffer = true, desc = "Select LSP document symbol" })

  set("n", "gD", function()
    vim.lsp.buf.type_definition()
  end, { silent = true, buffer = true, desc = "Go to type definition" })

  set("n", "K", function()
    vim.lsp.buf.hover()
  end, { silent = true, buffer = true })

  set("n", "L", function()
    vim.diagnostic.open_float(nil, {
      scope = "line",
      show_header = false,
      source = "always",
      focusable = false,
      border = "rounded",
    })
  end, { silent = true, buffer = true, desc = "Show diagnostics on current line" })

  -- vim.lsp.buf.code_action({
  --        filter = function(action)
  --            return action.isPreferred
  --        end,
  --        apply = true,
  --    })

  set("n", "<Leader>a", function()
    require("code_action_menu").open_code_action_menu()
  end, { silent = true, buffer = true, desc = "Select a code action" })

  set("v", "<Leader>a", function()
    vim.lsp.buf.range_code_action()
  end, { silent = true, buffer = true, desc = "Select a code action for the selected visual range" })

  set("n", "ga", function()
    require("code_action_menu").open_code_action_menu()
  end, { silent = true, buffer = true, desc = "Select a code action" })

  set("n", "[d", function()
    vim.diagnostic.goto_prev()
  end, { silent = true, buffer = true, desc = "Go to previous diagnostic" })

  set("n", "]d", function()
    vim.diagnostic.goto_next()
  end, { silent = true, buffer = true, desc = "Go to next diagnostic" })

  set("v", "<F8>", function()
    vim.lsp.buf.range_formatting()
  end, { silent = true, buffer = true, desc = "Format range" })

  vim.api.nvim_create_augroup("LspDiagnosticsConfig", { clear = true })
  if client.server_capabilities.semanticTokensProvider then
    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
      group = "LspDiagnosticsConfig",
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.semantic_tokens_full()
      end,
    })
  end

  vim.api.nvim_create_autocmd("CursorHold", {
    group = "LspDiagnosticsConfig",
    buffer = bufnr,
    callback = function()
      vim.diagnostic.open_float(nil, {
        scope = "cursor",
        show_header = false,
        source = "always",
        focusable = false,
        border = "rounded",
      })
    end,
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

  return cap
end

M.capabilities = make_capabilities()

M.handlers = {}

return M
