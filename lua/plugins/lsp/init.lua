return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "kosayoda/nvim-lightbulb",
    "nvim-telescope/telescope.nvim",
    "b0o/schemastore.nvim",
    "simrat39/inlay-hints.nvim",
    "stevearc/dressing.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "barrett-ruth/import-cost.nvim",
  },
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
    if vim.g.vscode then
      return
    end

    local capabilities = require("plugins.lsp.defaults").capabilities
    local detect = require("plenary.filetype").detect

    local lazy = require("bombeelu.utils").lazy
    local lsp = require("bombeelu.lsp")
    local on_attach = require("plugins.lsp.defaults").on_attach
    local rpt = require("bombeelu.repeat").mk_repeatable
    local set = require("bombeelu.utils").set

    local augroup = nvim.create_augroup
    local autocmd = nvim.create_autocmd

    local signs = {
      Error = " ✘",
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
      underline = {
        severity = "error",
      },
      signs = true,
      float = {
        show_header = false,
        source = "always",
      },
      update_in_insert = false,
    })

    vim.lsp.handlers["textDocument/hover"] =
      vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", focusable = false })

    lsp.eslint.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.json.setup({ on_attach = on_attach, capabilities = capabilities })
    -- lsp.relay.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.sorbet.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.tailwindcss.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.taplo.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.teal.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.zls.setup({ on_attach = on_attach, capabilities = capabilities })

    --- Sends an async request to all active clients attached to the current
    --- buffer.
    ---
    ---@param method (string) LSP method name
    ---@param params (table|nil) Parameters to send to the server
    ---@param handler (function|nil) See |lsp-handler|. Follows |lsp-handler-resolution|
    --
    ---@returns 2-tuple:
    ---  - Map of client-id:request-id pairs for all successful requests.
    ---  - Function which can be used to cancel all the requests. You could instead
    ---    iterate all clients and call their `cancel_request()` methods.
    ---
    ---@see |vim.lsp.buf_request()|
    -- local function request(method, params, handler)
    --   validate({
    --     method = { method, "s" },
    --     handler = { handler, "f", true },
    --   })
    --   return vim.lsp.buf_request(0, method, params, handler)
    -- end

    --- Hover info from ALL attached buffers
    function super_hover()
      local params = vim.lsp.util.make_position_params()
      -- request("textDocument/hover", params)
    end

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

    vim.api.nvim_create_augroup("LspDiagnosticsConfig", { clear = true })

    local function smart_diagnostic_hover()
      if vim.diagnostic.config().virtual_lines then
        return
      end

      vim.diagnostic.open_float(nil, {
        scope = "cursor",
        show_header = false,
        source = "always",
        focusable = false,
        border = "rounded",
      })
    end

    -- vim.api.nvim_create_autocmd("CursorHold", {
    --   group = "LspDiagnosticsConfig",
    --   callback = smart_diagnostic_hover,
    -- })
    --
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = "LspDiagnosticsConfig",
      callback = function()
        require("nvim-lightbulb").update_lightbulb({ ignore = { "null-ls" } })
      end,
    })

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
      "]d",
      rpt(function()
        vim.diagnostic.goto_next({ float = {
          border = "rounded",
          focusable = false,
        } })
      end),
      { silent = true, desc = "Go to next diagnostic" }
    )

    set(
      "n",
      "[d",
      rpt(function()
        vim.diagnostic.goto_prev({
          float = {
            border = "rounded",
            focusable = false,
          },
        })
      end),
      { silent = true, desc = "Go to previous diagnostic" }
    )

    set({ "n", "x" }, "<Leader>a", function()
      vim.lsp.buf.code_action()
    end, { silent = true, desc = "Select a code action" })

    set("n", "K", hover, { silent = true })

    augroup("LspCustom", { clear = true })

    autocmd("FileType", {
      pattern = { "LspInfo", "null-ls-info" },
      group = "LspCustom",
      callback = function()
        set("n", "q", lazy(vim.cmd.quit), { buffer = true })
      end,
    })
  end,
}
