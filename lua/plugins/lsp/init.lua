return {
  {
    "aznhe21/actions-preview.nvim",
    config = true,
    opts = {},
    lazy = true,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    enabled = true,
    event = "VeryLazy",
    priority = 1000,
    opt = {
      options = {
        show_source = true,
        multiple_diag_under_cursor = true,
      },
    },
    config = true,
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      {
        -- NOTE: This needs to be at the top
        "folke/neoconf.nvim",
        module = "neoconf",
        config = true,
        opts = {},
      },
      -- "iguanacucumber/magazine.nvim",
      -- "iguanacucumber/mag-nvim-lsp",
      -- "hrsh7th/nvim-cmp",
      -- "hrsh7th/cmp-nvim-lsp",
      "saghen/blink.cmp",
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
        lazy = true,
        init = function()
          local loaded = false
          local function check()
            local result = require("bombeelu.utils").root_pattern("tsconfig.json")(vim.uv.cwd() or vim.uv.os_homedir())

            if result then
              require("lazy").load({ plugins = { "nvim-vtsls" } })
              loaded = true
            end
          end
          check()
          vim.api.nvim_create_autocmd("DirChanged", {
            group = require("bu").nvim.augroup("vtsls.custom"),
            callback = function()
              if not loaded then
                check()
              end
            end,
          })
        end,
        -- cond = function()
        --   local result = require("bombeelu.utils").root_pattern("tsconfig.json")(vim.uv.cwd() or vim.uv.os_homedir())
        --
        --   return result
        -- end,
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
        "alexwu/nvim-lsp-selection-range",
        enabled = true,
        lazy = true,
        dev = true,
        opts = {},
        config = function()
          require("bombeelu.utils").on_attach(function(client, bufnr)
            local ft = vim.filetype.match({ buf = bufnr })
            if
              ft ~= "eruby"
              and client.name ~= "tailwindcss"
              and client.supports_method(vim.lsp.protocol.Methods.textDocument_selectionRange)
            then
              set(
                "n",
                "<CR>",
                require("lsp-selection-range").trigger,
                { noremap = true, buffer = bufnr, desc = "Select LSP selection range" }
              )
              set(
                "x",
                "<CR>",
                require("lsp-selection-range").expand,
                { noremap = true, buffer = bufnr, desc = "Expand LSP selection range" }
              )
            end
          end)
        end,
      },
      {
        "luckasRanarison/tailwind-tools.nvim",
        event = "VeryLazy",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
          -- "hrsh7th/nvim-cmp",
        },
        opts = {},
      },
    },
    config = function()
      local capabilities = require("plugins.lsp.defaults").capabilities

      local legendary = require("legendary")
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
          severity = vim.diagnostic.severity.ERROR,
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
          source = true,
        },
        jump = {
          -- float = {
          --   border = "rounded",
          --   focusable = false,
          -- },
        },
        update_in_insert = false,
      })

      -- vim.lsp.handlers[Methods.textDocument_diagnostic] = vim.lsp.with(vim.lsp.diagnostic.on_diagnostic, {
      --   virtual_text = {
      --     spacing = 4,
      --     severity = "error",
      --   },
      --   underline = {
      --     severity = "error",
      --   },
      --   float = {
      --     show_header = false,
      --     source = "always",
      --   },
      --   signs = true,
      --   update_in_insert = false,
      -- })
      --
      -- vim.lsp.handlers[Methods.textDocument_publishDiagnostics] =
      --   vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      --     virtual_text = {
      --       spacing = 4,
      --       severity = "error",
      --     },
      --     underline = {
      --       severity = "error",
      --     },
      --     float = {
      --       show_header = false,
      --       source = "always",
      --     },
      --     signs = true,
      --     update_in_insert = false,
      --   })

      autocmd("LspAttach", {
        group = bu.nvim.augroup("LspAttach_default"),
        callback = function(args)
          local buffer = args.buf
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          on_attach(client, buffer)
        end,
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

      lsp.markdown_oxide.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lsp.ruff.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })

      lsp.basedpyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          pyright = {
            -- Using Ruff's import organizer
            disableOrganizeImports = true,
          },
          python = {
            analysis = {
              -- Ignore all files for analysis to exclusively use Ruff for linting
              ignore = { "*" },
            },
          },
        },
      })

      -- lsp.ruby_lsp.setup({
      --   cmd = { "ruby-lsp" },
      --   on_attach = function(client, buffer)
      --     on_attach(client, buffer)
      --   end,
      --   capabilities = capabilities,
      --   filetypes = { "ruby", "eruby" },
      --   init_options = {
      --     formatter = "auto",
      --     features_configuration = { inlay_hint = { enable_all = true } },
      --     experimentalFeaturesEnabled = true,
      --     erbSupport = true,
      --   },
      -- })
      lsp.biome.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "typescript", "typescriptreact" },
      })
      lsp.html.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.htmx.setup({ on_attach = on_attach, capabilities = capabilities, filetypes = { "html", "templ", "eruby" } })
      lsp.sourcekit.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.theme_check.setup({ on_attach = on_attach, capabilities = capabilities })
      lsp.typos_lsp.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        init_options = {
          -- Custom config. Used together with a config file found in the workspace or its parents,
          -- taking precedence for settings declared in both.
          -- Equivalent to the typos `--config` cli argument.
          -- config = "~/code/typos-lsp/crates/typos-lsp/tests/typos.toml",
          -- How typos are rendered in the editor, can be one of an Error, Warning, Info or Hint.
          -- Defaults to error.
          diagnosticSeverity = "Warning",
        },
      })
      lsp.harper_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        filetypes = { "modelfile", "markdown" },
        settings = {
          ["harper-ls"] = {
            diagnosticSeverity = "hint", -- Can also be "information", "warning", or "error"
            linters = {
              spell_check = true,
              spelled_numbers = false,
              an_a = true,
              sentence_capitalization = true,
              unclosed_quotes = true,
              wrong_quotes = false,
              long_sentences = true,
              repeated_words = true,
              spaces = true,
              matcher = true,
              correct_number_suffix = true,
              number_suffix_capitalization = true,
              multiple_sequential_pronouns = true,
              linking_verbs = false,
              avoid_curses = false,
            },
          },
        },
      })

      -- Workaround for truncating long TypeScript inlay hints.
      -- TODO: Remove this if https://github.com/neovim/neovim/issues/27240 gets addressed.
      local inlay_hint_handler = vim.lsp.handlers[Methods.textDocument_inlayHint]
      vim.lsp.handlers[Methods.textDocument_inlayHint] = function(err, result, ctx, config)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client and client.name == "vtsls" then
          result = vim.iter(result):map(function(hint)
            if type(hint.label) == "string" then
              local label = hint.label ---@type string
              if string.len(label) >= 30 then
                label = label:sub(1, 29) .. "…"
              end
              hint.label = label
            end
            return hint
          end)
        end

        inlay_hint_handler(err, result, ctx, config)
      end

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

      legendary.keymap({
        "<Leader>a",
        function()
          require("actions-preview").code_actions()
        end,
        modes = { "n", "x" },
        opts = { silent = true, desc = "Select a code action" },
      })

      set({ "n", "x" }, "<leader>cl", vim.lsp.codelens.run, { desc = "Run Code Lens" })

      -- set("n", "gd", function()
      --   vim.lsp.buf.definition({ reuse_win = true })
      -- end, { silent = true, desc = "Go to definition" })

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
      -- set("i", "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

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
}
