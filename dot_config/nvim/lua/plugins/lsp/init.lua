local capabilities = require("plugins.lsp.defaults").capabilities
local detect = require("plenary.filetype").detect

local lazy = require("bombeelu.utils").lazy
local lsp = require("bombeelu.lsp")
local on_attach = require("plugins.lsp.defaults").on_attach
local repeatable = require("bombeelu.repeat").mk_repeatable
local set = require("bombeelu.utils").set
local telescope = require("telescope.builtin")

local augroup = nvim.create_augroup
local autocmd = nvim.create_autocmd

local signs = {
  Error = "✘ ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

for name, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. name
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = false,
  -- virtual_lines = {
  --   only_current_line = true,
  -- },
  virtal_lines = true,
  underline = {},
  signs = true,
  float = {
    show_header = false,
    source = "always",
  },
  update_in_insert = false,
})

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", focusable = false })

lsp.clangd.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.eslint.setup({ on_attach = on_attach, capabilities = capabilities })
-- lsp.go.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.json.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.lua.setup({ on_attach = on_attach, capabilities = capabilities })
-- lsp.ruby.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.relay.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.rust.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.sorbet.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.tailwindcss.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.teal.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.taplo.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.typescript.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.zls.setup({ on_attach = on_attach, capabilities = capabilities })

local function hover()
  local filetype = detect(vim.api.nvim_buf_get_name(0))
  if vim.tbl_contains({ "vim", "help" }, filetype) then
    vim.cmd("h " .. vim.fn.expand("<cword>"))
  elseif vim.tbl_contains({ "man" }, filetype) then
    vim.cmd("Man " .. vim.fn.expand("<cword>"))
  elseif vim.fn.expand("%:t") == "Cargo.toml" then
    require("crates").show_popup()
  else
    vim.lsp.buf.hover()
  end
end

set("n", "gd", lazy(telescope.lsp_definitions), { desc = "Go to definition" })
set("n", "gr", lazy(telescope.lsp_references), { desc = "Go to references" })
set("n", "gi", lazy(telescope.lsp_implementations), { desc = "Go to implementation" })
set("n", "<Leader>s", lazy(telescope.lsp_document_symbols), { desc = "Select LSP document symbol" })

set("n", "gy", function()
  vim.lsp.buf.type_definition()
end, { silent = true, desc = "Go to type definition" })

set("n", "L", function()
  vim.diagnostic.open_float(nil, {
    scope = "line",
    show_header = false,
    source = "always",
    focusable = false,
    border = "rounded",
  })
end, { silent = true, desc = "Show diagnostics on current line" })

set(
  "n",
  "]g",
  repeatable(function()
    vim.diagnostic.goto_next()
  end),
  { silent = true, desc = "Go to next diagnostic" }
)

set(
  "n",
  "[g",
  repeatable(function()
    vim.diagnostic.goto_prev()
  end),
  { silent = true, desc = "Go to previous diagnostic" }
)

set("n", "K", hover, { silent = true })

augroup("LspCustom", { clear = true })

autocmd("FileType", {
  pattern = { "LspInfo", "null-ls-info" },
  group = "LspCustom",
  callback = function()
    set("n", "q", lazy(nvim.cmd.quit), { buffer = true })
  end,
})

autocmd("DiagnosticChanged", {
  group = "LspCustom",
  callback = function()
    vim.diagnostic.setloclist({ open = false })
  end,
})
