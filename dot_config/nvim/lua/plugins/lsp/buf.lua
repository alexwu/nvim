local util = require("vim.lsp.util")

local M = {}

---@private
--- Sends an async request to all active clients attached to the current
--- buffer.
---
---@param method (string) LSP method name
---@param params (optional, table) Parameters to send to the server
---@param handler (optional, functionnil) See |lsp-handler|. Follows |lsp-handler-resolution|
--
---@returns 2-tuple:
---  - Map of client-id:request-id pairs for all successful requests.
---  - Function which can be used to cancel all the requests. You could instead
---    iterate all clients and call their `cancel_request()` methods.
---
---@see |vim.lsp.buf_request()|
local function request(method, params, handler)
  vim.validate({
    method = { method, "s" },
    handler = { handler, "f", true },
  })
  return vim.lsp.buf_request(0, method, params, handler)
end

function M.semantic_tokens_full()
  local params = { textDocument = util.make_text_document_params() }
  require("plugins.lsp.semantic_tokens")._save_tick(vim.api.nvim_get_current_buf())
  return request("textDocument/semanticTokens/full", params)
end

function M.semantic_tokens_range()
  local params = { textDocument = util.make_text_document_params() }
  require("plugins.lsp.semantic_tokens")._save_tick(vim.api.nvim_get_current_buf())
  return request("textDocument/semanticTokens/full", params)
end

function M.selection_range() end

return M
