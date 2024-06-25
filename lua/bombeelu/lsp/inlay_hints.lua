local augroup = nvim.create_augroup
local autocmd = nvim.create_autocmd

local M = {}

function M.setup()
  augroup("LspAttach_inlayhints", {})
  autocmd("LspAttach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true, {
          bufnr = bufnr,
        })
      end
    end,
  })

  autocmd("LspDetach", {
    group = "LspAttach_inlayhints",
    callback = function(args)
      if not (args.data and args.data.client_id) then
        return
      end

      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)

      if client and client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(false, {
          bufnr = bufnr,
        })
      end
    end,
  })
end

return M
