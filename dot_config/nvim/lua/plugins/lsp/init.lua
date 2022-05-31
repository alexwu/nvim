local augroup = nvim.create_augroup
local autocmd = nvim.create_autocmd
local capabilities = require("plugins.lsp.defaults").capabilities
local on_attach = require("plugins.lsp.defaults").on_attach
local lazy = require("bombeelu.utils").lazy
local lsp = require("bombeelu.lsp")
local lsp_installer = require("nvim-lsp-installer")
local set = vim.keymap.set

lsp_installer.setup({
  ensure_installed = {
    "clangd",
    "eslint",
    "gopls",
    -- "graphql",
    "jsonls",
    "rust_analyzer",
    "sumneko_lua",
    "tsserver",
  },
})

lsp.clangd.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.eslint.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.go.setup({ on_attach = on_attach, capabilities = capabilities })
-- lsp.graphql.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.json.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.lua.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.rust.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.sorbet.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.teal.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.typescript.setup({ on_attach = on_attach, capabilities = capabilities })
lsp.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })

augroup("LspCustom", { clear = true })

autocmd("FileType", {
  pattern = { "LspInfo", "null-ls-info" },
  group = "LspCustom",
  callback = function()
    set("n", "q", lazy(nvim.ex.quit), { buffer = true })
  end,
})

autocmd("DiagnosticChanged", {
  group = "LspCustom",
  callback = function()
    vim.diagnostic.setloclist({ open = false })
  end,
})
