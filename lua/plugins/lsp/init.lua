return {
  {
    "aznhe21/actions-preview.nvim",
    config = true,
    opts = {},
    lazy = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    cond = function()
      return not vim.g.vscode
    end,
    dependencies = {
      {
        -- NOTE: This needs to be at the top
        "folke/neoconf.nvim",
        module = "neoconf",
        config = true,
        opts = {},
      },
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      {
        "kosayoda/nvim-lightbulb",
        config = true,
        opts = {
          autocmd = {
            enabled = false,
          },
          action_kinds = { "quickfix", "refactor.rewrite" },
          ignore = {
            clients = {
              "null-ls",
            },
            ft = { "neo-tree" },
          },
        },
      },
      "nvim-telescope/telescope.nvim",
      "b0o/schemastore.nvim",
      "stevearc/dressing.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "yioneko/nvim-vtsls",
        config = function()
          require("lspconfig.configs").vtsls = require("vtsls").lspconfig
        end,
        keys = {
          {
            "gD",
            function()
              require("vtsls").commands.goto_source_definition(0)
            end,
            desc = "Goto Source Definition",
          },
          {
            "<leader>co",
            function()
              require("vtsls").commands.organize_imports(0)
            end,
            desc = "Organize Imports",
          },
          {
            "<leader>cM",
            function()
              require("vtsls").commands.add_missing_imports(0)
            end,
            desc = "Add missing imports",
          },
          {
            "<leader>cu",
            function()
              require("vtsls").commands.remove_unused_imports(0)
            end,
            desc = "Remove unused imports",
          },
          {
            "<leader>cU",
            function()
              require("vtsls").commands.remove_unused(0)
            end,
            desc = "Remove unused",
          },
        },
      },
      {
        "zbirenbaum/neodim",
        enabled = true,
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
      {
        "camilledejoye/nvim-lsp-selection-range",
        opts = {},
        config = function()
          require("bombeelu.utils").on_attach(function(client, bufnr)
            if client.name ~= "tailwindcss" and client.supports_method("textDocument/selectionRange") then
              set(
                "n",
                "vv",
                [[<cmd>lua require('lsp-selection-range').trigger()<CR>]],
                { noremap = true, buffer = bufnr, desc = "Select LSP selection range" }
              )
              set(
                "v",
                "vv",
                [[<cmd>lua require('lsp-selection-range').expand()<CR>]],
                { noremap = true, buffer = bufnr }
              )
            end
          end)
        end,
      },
      {
        "luckasRanarison/tailwind-tools.nvim",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          "hrsh7th/nvim-cmp",
        },
        opts = {},
      },
    },
    config = function()
      local capabilities = require("plugins.lsp.defaults").capabilities

      local lazy = require("bombeelu.utils").lazy
      local lsp = require("bombeelu.lsp")
      local on_attach = require("plugins.lsp.defaults").on_attach
      local set = require("bombeelu.utils").set

      local Methods = vim.lsp.protocol.Methods

      local augroup = nvim.create_augroup
      local autocmd = nvim.create_autocmd

      vim.diagnostic.config({
        virtual_text = false,
        underline = {
          severity = "error",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ✘",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
        float = {
          show_header = false,
          source = "always",
        },
        jump = {
          float = {
            border = "rounded",
            focusable = false,
          },
        },
        update_in_insert = false,
      })

      vim.lsp.handlers[Methods.textDocument_diagnostic] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
        virtual_text = {
          spacing = 4,
          severity = "error",
        },
        underline = {
          severity = "error",
        },
        float = {
          show_header = false,
          source = "always",
        },
        signs = true,
        update_in_insert = false,
      })

      vim.lsp.handlers[Methods.textDocument_publishDiagnostics] =
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
          virtual_text = {
            spacing = 4,
            severity = "error",
          },
          underline = {
            severity = "error",
          },
          float = {
            show_header = false,
            source = "always",
          },
          signs = true,
          update_in_insert = false,
        })

      require("mason").setup()
      require("mason-lspconfig").setup()

      -- vim.lsp.handlers["textDocument/hover"] =
      --   vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded", focusable = false })

      lsp.eslint.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.json.setup({ on_attach = on_attach, capabilities = capabilities })
      -- lsp.relay.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.tailwindcss.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          classAttributes = { "class", "className", "class:list", "classList", "ngClass", "classes" },
        },
      })
      lsp.taplo.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.yamlls.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.zls.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.lua.setup({ on_attach = on_attach, capabilities = capabilities })

      local function add_ruby_deps_command(client, bufnr)
        vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
          local params = vim.lsp.util.make_text_document_params()
          local showAll = opts.args == "all"

          client.request("rubyLsp/workspace/dependencies", params, function(error, result)
            if error then
              print("Error showing deps: " .. error)
              return
            end

            local qf_list = {}
            for _, item in ipairs(result) do
              if showAll or item.dependency then
                table.insert(qf_list, {
                  text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
                  filename = item.path,
                })
              end
            end

            vim.fn.setqflist(qf_list)
            vim.cmd("copen")
          end, bufnr)
        end, {
          nargs = "?",
          complete = function()
            return { "all" }
          end,
        })
      end

      lsp.ruby_lsp.setup({
        cmd = { "ruby-lsp" },
        on_attach = function(client, buffer)
          on_attach(client, buffer)
          add_ruby_deps_command(client, buffer)
        end,
        capabilities = capabilities,
        filetypes = { "ruby" },
      })
      lsp.biome.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.htmx.setup({ on_attach = on_attach, capabilities = capabilities, filetypes = { "html", "templ", "eruby" } })
      lsp.sourcekit.setup({ on_attach = on_attach, capabilities = capabilities })

      lsp.vtsls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          typescript = {
            inlayHints = {
              parameterNames = { enabled = "literals" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
              enumMemberValues = { enabled = true },
            },
          },
        },
      })

      lsp.gdscript.setup({ on_attach = on_attach, capabilities = capabilities })

      local function hover()
        local filetype = vim.filetype.match({ buf = 0 })
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

      augroup("LspDiagnosticsConfig", { clear = true })

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

      set("n", "K", hover, { silent = true, desc = "Hover" })
      set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

      set({ "n", "i", "s" }, "<c-f>", function()
        if not require("noice.lsp").scroll(4) then
          return "<c-f>"
        end
      end, { silent = true, expr = true })

      set({ "n", "i", "s" }, "<c-b>", function()
        if not require("noice.lsp").scroll(-4) then
          return "<c-b>"
        end
      end, { silent = true, expr = true })

      require("bombeelu.lsp.inlay_hints").setup()

      augroup("LspCustom", { clear = true })
      autocmd("FileType", {
        pattern = { "LspInfo", "null-ls-info" },
        group = "LspCustom",
        callback = function()
          set("n", "q", lazy(vim.cmd.quit), { buffer = true })
        end,
      })
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    dependencies = { "neovim/nvim-lspconfig", "yioneko/nvim-vtsls" },
    cond = function()
      return not vim.g.vscode
    end,
    opts = {},
    config = true,
  },
}
