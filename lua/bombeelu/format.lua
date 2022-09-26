local lazy = require("bombeelu.utils").lazy
local find_node_modules = require("bombeelu.utils").find_node_modules
local set = require("bombeelu.utils").set
local defaults = require("formatter.defaults")
local detect = require("plenary.filetype").detect
local util = require("formatter.util")

local function filename()
  return util.escape_path(util.get_current_buffer_file_path())
end

local function bedazzle()
  return {
    -- exe = vim.fs.normalize("~/Code/personal/formatters/bedazzle/target/release/bedazzle"),
    exe = vim.fs.normalize("~/Code/personal/formatters/bedazzle/target/release/bedazzle-cli"),
    -- exe = vim.fs.normalize("~/Code/personal/formatters/bedazzle/target/debug/bedazzle-cli"),
    name = "Bedazzle",
    args = { "--stdin" },
    stdin = true,
  }
end

local function prettier()
  local node_modules = find_node_modules(vim.loop.cwd())
  if not node_modules then
    return defaults.prettier()
  end

  return {
    exe = table.concat({ node_modules, "node_modules", ".bin", "prettier" }, "/"),
    name = "Prettier",
    args = {
      "--stdin-filepath",
      filename(),
    },
    stdin = true,
    try_node_modules = true,
  }
end

local function rubyfmt()
  return {
    exe = "rubyfmt",
    stdin = true,
  }
end

local function rufo()
  return {
    exe = "echo",
    name = "Rufo",
    args = {
      "-",
      "|",
      "rufo",
      "--filename",
      util.escape_path(util.get_current_buffer_file_path()),
    },
    stdin = true,
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
    typescript = { dprint, require("formatter.filetypes.typescript").denofmt, prettier },
    typescriptreact = { dprint, require("formatter.filetypes.typescript").denofmt, prettier },
    javascript = { dprint, require("formatter.filetypes.typescript").denofmt, prettier },
    javascriptreact = { dprint, require("formatter.filetypes.typescript").denofmt, prettier },
    go = { require("formatter.filetypes.go").gofmt },
    eruby = { rufo },
    graphql = { prettier },
    json = { dprint, prettier },
    jsonc = { dprint, prettier },
    html = { prettier },
    css = { prettier },
    ruby = { rubyfmt, rufo, prettier, bedazzle },
    rust = {
      require("formatter.filetypes.rust").rustfmt,
    },
    lua = { require("formatter.filetypes.lua").stylua },
    python = {
      require("formatter.filetypes.python").black,
    },
    toml = { dprint },
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

set({ "n" }, { "<F8>", "<Leader>y", "gq" }, lazy(format), { silent = true, desc = "Format" })
set({ "i" }, { "<F8>" }, lazy(format), { silent = true, desc = "Format" })
set({ "v" }, { "<F8>", "<Leader>y" }, lazy(format_range), { silent = true, desc = "Format range" })

vim.cmd([[
function! s:formatter_complete(...)
  return luaeval('require("formatter.complete").complete(_A)', a:000)
endfunction

command! -nargs=? -range=% -bar
\   -complete=customlist,s:formatter_complete
\   Fmt lua require("formatter.format").format(
\     <q-args>, <q-mods>, <line1>, <line2>)
]])

local function upper_first(str)
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
        local name = vim.F.if_nil(formatter.name, formatter.exe)
        vim.api.nvim_buf_create_user_command(bufnr, upper_first(name), function(opts)
          require("formatter.format").format(exe, opts.mods, opts.line1, opts.line2)
        end, { range = "%", bar = true })
      end
    end
  end,
})
