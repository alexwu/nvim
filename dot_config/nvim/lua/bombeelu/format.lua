local lazy = require("bombeelu.utils").lazy
local set = require("bombeelu.utils").set
local defaults = require("formatter.defaults")
local stylua = require("formatter.filetypes.lua").stylua
local black = require("formatter.filetypes.python").black
local rustfmt = require("formatter.filetypes.rust").rustfmt
local gofmt = require("formatter.filetypes.go").gofmt
local denofmt = require("formatter.filetypes.typescript").denofmt

local function rubyfmt()
  return {
    exe = "rubyfmt",
    stdin = true,
  }
end

local function rufo()
  return {
    exe = "rufo",
    args = { vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    stdin = false,
  }
end

local function lsp_formatters(range)
  local clients = vim.lsp.get_active_clients({ bufnr = nvim.get_current_buf() })

  return vim.tbl_filter(function(client)
    if client.name == "tsserver" or client.name == "copilot" or client.name == "sumneko_lua" then
      return false
    end

    if range then
      return client.server_capabilities.documentRangeFormattingProvider
    end

    return client.server_capabilities.documentFormattingProvider
  end, clients)
end

require("formatter").setup({
  logging = false,
  filetype = {
    typescript = { denofmt, defaults.prettier },
    typescriptreact = { denofmt, defaults.prettier },
    javascript = { denofmt, defaults.prettier },
    javascriptreact = { denofmt, defaults.prettier },
    go = { gofmt },
    graphql = { defaults.prettier },
    json = { defaults.prettier },
    jsonc = { defaults.prettier },
    html = { defaults.prettier },
    css = { defaults.prettier },
    ruby = { rubyfmt, rufo },
    rust = { rustfmt },
    lua = { stylua },
    python = { black },
  },
})

local function use_lsp(range)
  return not vim.tbl_isempty(lsp_formatters(range))
end

local function format()
  if use_lsp() then
    vim.lsp.buf.format({
      async = true,
      filter = function(client)
        return client.name ~= "tsserver" and client.name ~= "jsonls" and client.name ~= "sumneko_lua"
      end,
    })
  else
    local formatter_ft = require("formatter.config").values[vim.bo.ft]
    if not formatter_ft or vim.tbl_isempty(formatter_ft) then
      vim.notify(string.format("No formatter available for ft: %s", vim.bo.ft), vim.log.levels.WARN)
    else
      require("formatter.format").format()
    end
  end
end

local function format_range()
  if use_lsp(true) then
    vim.lsp.buf.range_formatting({
      filter = function(client)
        return client.name ~= "tsserver" and client.name ~= "jsonls" and client.name ~= "sumneko_lua"
      end,
    })
  else
  end
end

set({ "n" }, { "<F8>", "<Leader>y", "gy" }, lazy(format), { silent = true, desc = "Format" })
set({ "v" }, { "<F8>", "<Leader>y", "gy" }, lazy(format_range), { silent = true, desc = "Format range" })
