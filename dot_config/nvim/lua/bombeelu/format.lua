local lazy = require("bombeelu.utils").lazy
local set = require("bombeelu.utils").set
local defaults = require("formatter.defaults")
local detect = require("plenary.filetype").detect

local function organize_imports_sync()
  local bufnr = vim.api.nvim_get_current_buf()
  local tsserver_is_attached = false
  for _, client in ipairs(vim.lsp.buf_get_clients(bufnr)) do
    if client.name == "tsserver" then
      tsserver_is_attached = true
      break
    end
  end

  if tsserver_is_attached then
    require("nvim-lsp-ts-utils").organize_imports_sync(bufnr)
  end
end

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

local function dprint()
  return {
    exe = "dprint",
    args = { "fmt", "--stdin", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
    stdin = true,
  }
end

local function lsp_formatters(range)
  local clients = vim.lsp.get_active_clients({ bufnr = nvim.get_current_buf() })

  return vim.tbl_filter(function(client)
    if client.name == "tsserver" or client.name == "copilot" or client.name == "sumneko_lua" then
      return false
    end

    if range and client.server_capabilities.documentRangeFormattingProvider ~= nil then
      return client.server_capabilities.documentRangeFormattingProvider
    end

    return client.server_capabilities.documentFormattingProvider ~= nil
  end, clients)
end

require("formatter").setup({
  logging = false,
  filetype = {
    typescript = { dprint, require("formatter.filetypes.typescript").denofmt, defaults.prettier },
    typescriptreact = { dprint, require("formatter.filetypes.typescript").denofmt, defaults.prettier },
    javascript = { dprint, require("formatter.filetypes.typescript").denofmt, defaults.prettier },
    javascriptreact = { dprint, require("formatter.filetypes.typescript").denofmt, defaults.prettier },
    go = { require("formatter.filetypes.go").gofmt },
    graphql = { defaults.prettier },
    json = { defaults.prettier },
    jsonc = { defaults.prettier },
    html = { defaults.prettier },
    css = { defaults.prettier },
    ruby = { rubyfmt, rufo },
    rust = {
      require("formatter.filetypes.rust").rustfmt,
    },
    lua = { require("formatter.filetypes.lua").stylua },
    python = {
      require("formatter.filetypes.python").black,
    },
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

vim.cmd([[
function! s:formatter_complete(...)
  return luaeval('require("formatter.complete").complete(_A)', a:000)
endfunction

command! -nargs=? -range=% -bar
\   -complete=customlist,s:formatter_complete
\   Fmt lua require("formatter.format").format(
\     <q-args>, <q-mods>, <line1>, <line2>)
]])

function upper_first(str)
  return (str:gsub("^%l", string.upper))
end

nvim.create_augroup("bombeelu.format", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", {
  group = "bombeelu.format",
  callback = function(o)
    local bufnr = o.buf
    local config = require("formatter.config")
    local formatters = config.formatters_for_filetype(detect(nvim.buf_get_name(bufnr)))
    for _, formatter_function in ipairs(formatters) do
      local formatter = formatter_function()
      if formatter ~= nil then
        local exe = formatter.exe
        vim.api.nvim_buf_create_user_command(bufnr, upper_first(exe), function(opts)
          require("formatter.format").format(exe, opts.mods, opts.line1, opts.line2)
        end, { range = "%", bar = true })
      end
    end
  end,
})
