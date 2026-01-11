local util = vim.lsp.util

local ___ =
  "\n─────────────────────────────────────────────────────────────────────────────\n"

-- Copied from
-- <https://github.com/lewis6991/hover.nvim/issues/34#issuecomment-1625662866>
-- and
-- <https://github.com/WillEhrendreich/nvimconfig/blob/c7d8aed0291ee74887dd3a4ea512398a406b82a6/lua/plugins/hover.lua>.
-- local LSPWithDiagSource = {
--   name = "LSPWithDiag",
--   priority = 1000,
--   enabled = function()
--     return true
--   end,
--   execute = function(opts, done)
--     local params = util.make_position_params()
--     vim.lsp.buf_request_all(0, "textDocument/hover", params, function(responses)
--       vim.print(responses)
--       local value = ""
--       for _, response in pairs(responses) do
--         local result = response.result
--         if result and result.contents and result.contents.value then
--           if value ~= "" then
--             value = value .. ___
--           end
--           value = value .. result.contents.value
--         end
--       end
--
--       local _, row = unpack(vim.fn.getpos("."))
--       local lineDiag = vim.diagnostic.get(0, { lnum = row - 1 })
--       for _, d in pairs(lineDiag) do
--         if d.message then
--           if value ~= "" then
--             value = value .. ___
--           end
--           value = value .. string.format("*%s* %s", d.source, d.message)
--         end
--       end
--       value = value:gsub("\r", "")
--
--       if value ~= "" then
--         done({ lines = vim.split(value, "\n", true), filetype = "markdown" })
--       else
--         done()
--       end
--     end)
--   end,
-- }

local get_clients = vim.lsp.get_clients

local LSPServerHover = function(server_name)
  return {
    name = string.format("LSP[%s]", server_name),
    priority = 1002, -- above diagnostics

    enabled = function(bufnr)
      return #get_clients({ bufnr = bufnr, name = server_name, method = "textDocument/hover" }) > 0
    end,

    execute = function(opts, done)
      local client = get_clients({ bufnr = opts.bufnr, name = server_name, method = "textDocument/hover" })[1]
      if not client then
        return
      end

      local params = util.make_position_params(0, client.offset_encoding)

      client:request("textDocument/hover", params, function(err, result)
        if result and result.contents and result.contents.value then
          local value = result.contents.value
          done({ lines = vim.split(value, "\n", true), filetype = "markdown" })
        elseif result and result.contents then
          local value = result.contents
          done({ lines = vim.split(value, "\n", true), filetype = "markdown" })
        else
          if err then
            print(err)
          end
          done()
        end
      end)
    end,
  }
end

return {
  "lewis6991/hover.nvim",
  enabled = true,
  config = function()
    local hover = require("hover")
    hover.config({
      providers = {
        "hover.providers.diagnostic",
        "hover.providers.lsp",
        "hover.providers.dap",
        "hover.providers.man",
        -- "hover.providers.dictionary",
        'hover.providers.gh',
        'hover.providers.gh_user',
        -- 'hover.providers.jira',
        'hover.providers.fold_preview',
        -- 'hover.providers.highlight',
      },
      preview_opts = {
        border = "rounded",
      },
      -- Whether the contents of a currently open hover window should be moved
      -- to a :h preview-window when pressing the hover keymap.
      preview_window = false,
      title = true,
      mouse_providers = {
        "hover.providers.lsp",
      },
      mouse_delay = 1000,
    })
    set("n", "gK", hover.open, { desc = "hover.nvim (open)" })
    -- set("n", "gK", hover.hover_select, { desc = "hover.nvim select" })

    -- require("bombeelu.utils").on_attach(function(client, buffer)
    --   if not client or not client:supports_method(vim.lsp.protocol.Methods.textDocument_hover) then
    --     return
    --   end
    --
    --   local providers = require("hover.providers").providers
    --   local client_name = string.format("LSP[%s]", client.name)
    --
    --   if vim.iter(providers):any(function(provider)
    --     return provider.name == client_name
    --   end) then
    --     return
    --   end
    --
    --   hover.register(LSPServerHover(client.name))
    -- end)
  end,
}
