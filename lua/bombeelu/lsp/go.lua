local ft = require("plenary.filetype")
local defaults = require("plugins.lsp.defaults")

local go = {}

function go.setup(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  if ft.detect(vim.api.nvim_buf_get_name(bufnr)) ~= "go" then
    return
  end

  local o = vim.F.if_nil(opts, {})
  local capabilities = vim.F.if_nil(o.capabilities, defaults.capabilities)
  local on_attach = vim.F.if_nil(o.on_attach, defaults.on_attach)

  require("go").setup({
    -- gopls_cmd = { install_root_dir .. "/go/gopls" },
    fillstruct = "gopls",
    dap_debug = true,
    dap_debug_gui = true,
    lsp_on_attach = on_attach,
    lsp_diag_hdlr = false,
    lsp_cfg = {
      capabilities = capabilities,
      -- settings = {
      --   gopls = {
      --     experimentalPostfixCompletions = true,
      --     analyses = {
      --       unusedparams = true,
      --       shadow = true,
      --     },
      --     staticcheck = true,
      --   },
      -- },
      -- init_options = {
      --   usePlaceholders = true,
      -- },
    },
  })
end

return go
