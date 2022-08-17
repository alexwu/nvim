local path = require("nvim-lsp-installer.core.path")
local install_root_dir = path.concat({ vim.fn.stdpath("data"), "lsp_servers" })
local ft = require("plenary.filetype")

local go = {}

function go.setup(opts)
  local bufnr = vim.api.nvim_get_current_buf()
  if ft.detect(vim.api.nvim_buf_get_name(bufnr)) ~= "go" then
    return
  end

  require("go").setup({
    gopls_cmd = { install_root_dir .. "/go/gopls" },
    fillstruct = "gopls",
    dap_debug = true,
    dap_debug_gui = true,
    lsp_on_attach = opts.on_attach,
    lsp_diag_hdlr = false,
    lsp_cfg = {
      capabilities = opts.capabilities,
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
