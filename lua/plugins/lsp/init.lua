return {
  "neovim/nvim-lspconfig",
  event = "VeryLazy",
  dependencies = {
    {
      -- NOTE: This needs to be at the top
      "folke/neoconf.nvim",
      module = "neoconf",
      config = function()
        require("neoconf").setup()
      end,
    },
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
    "kosayoda/nvim-lightbulb",
    "nvim-telescope/telescope.nvim",
    "b0o/schemastore.nvim",
    "stevearc/dressing.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "folke/neodev.nvim",
    {
      "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
      config = function()
        require("lsp_lines").setup()
        vim.diagnostic.config({ virtual_lines = false })

        vim.keymap.set("n", "<Leader>L", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
      end,
    },
    {
      "lvimuser/lsp-inlayhints.nvim",
      branch = "anticonceal",
      config = function()
        require("lsp-inlayhints").setup()

        vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
        vim.api.nvim_create_autocmd("LspAttach", {
          group = "LspAttach_inlayhints",
          callback = function(args)
            if not (args.data and args.data.client_id) then
              return
            end

            local bufnr = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            require("lsp-inlayhints").on_attach(client, bufnr)
          end,
        })
      end,
    },
    {
      "jose-elias-alvarez/typescript.nvim",
      ft = { "typescript", "typescriptreact", "typescript.tsx", "javascript", "javascriptreact" },
      cond = function()
        return not vim.g.vscode
      end,
      config = function()
        require("bombeelu.lsp").typescript.setup()
      end,
    },
    {
      "p00f/clangd_extensions.nvim",
      ft = { "c", "cpp" },
      config = function()
        require("bombeelu.lsp").clangd.setup()
      end,
    },
    {
      "zbirenbaum/neodim",
      event = "LspAttach",
      config = function()
        require("neodim").setup({
          alpha = 0.5,
          blend_color = "#282a36",
          update_in_insert = {
            enable = false,
            delay = 400,
          },
          hide = {
            virtual_text = true,
            signs = false,
            underline = true,
          },
        })
      end,
    },
  },
  init = function()
    vim.g.navic_silence = true
  end,
  cond = function()
    return not vim.g.vscode
  end,
  config = function()
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

    -- local null_ls_token = nil
    -- local ltex_token = nil
    --
    -- vim.lsp.handlers["$/progress"] = function(_, result, ctx)
    --   local value = result.value
    --   if not value.kind then
    --     return
    --   end
    --
    --   local client_id = ctx.client_id
    --   local name = vim.lsp.get_client_by_id(client_id).name
    --
    --   if name == "null-ls" then
    --     if result.token == null_ls_token then
    --       return
    --     end
    --     if value.title == "formatting" then
    --       null_ls_token = result.token
    --       return
    --     end
    --   end
    --
    --   if name == "ltex" then
    --     if result.token == ltex_token then
    --       return
    --     end
    --     if value.title == "Checking document" then
    --       ltex_token = result.token
    --       return
    --     end
    --   end
    --
    --   vim.notify(value.message, "info", {
    --     title = value.title,
    --   })
    -- end
    --
    require("mason").setup()
    require("mason-lspconfig").setup()

    -- vim.lsp.handlers["textDocument/hover"] =
    --   vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", focusable = false })

    lsp.eslint.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.json.setup({ on_attach = on_attach, capabilities = capabilities })
    -- lsp.relay.setup({ on_attach = on_attach, capabilities = capabilities })
    -- lsp.sorbet.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.tailwindcss.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.taplo.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.teal.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.zls.setup({ on_attach = on_attach, capabilities = capabilities })
    lsp.lua.setup({ on_attach = on_attach, capabilities = capabilities })
    -- lsp.sorbet.setup({ on_attach = on_attach, capabilities = capabilities })
    -- lsp.shopify_theme_check.setup({ on_attach = on_attach, capabilities = capabilities })

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
        vim.diagnostic.goto_next({
          float = {
            border = "rounded",
            focusable = false,
          },
        })
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

    set({ "n", "x" }, { "<Leader>a", "<C-.>" }, function()
      vim.lsp.buf.code_action()
    end, { silent = true, desc = "Select a code action" })

    set("n", "K", hover, { silent = true })

    vim.keymap.set({ "n", "i", "s" }, "<c-f>", function()
      if not require("noice.lsp").scroll(4) then
        return "<c-f>"
      end
    end, { silent = true, expr = true })

    vim.keymap.set({ "n", "i", "s" }, "<c-b>", function()
      if not require("noice.lsp").scroll(-4) then
        return "<c-b>"
      end
    end, { silent = true, expr = true })

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
