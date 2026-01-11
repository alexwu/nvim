return {
  {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      {
        "folke/snacks.nvim",
        opts = {
          terminal = {},
        },
      },
    },
    event = "LspAttach",
    opts = {
      backend = "vim",
      picker = "snacks",
    },
  },
  {
    "mhanberg/output-panel.nvim",
    version = "*",
    event = "LspAttach",
    config = function()
      require("output_panel").setup({
        max_buffer_size = 5000, -- default
      })
    end,
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
    config = function(_, opts)
      require("tiny-inline-diagnostic").setup(opts)

      Snacks.toggle
        .new({
          id = "tiny-inline-diagnostic",
          name = "Pretty Diagnostics",
          get = function()
            return require("tiny-inline-diagnostic.diagnostic").user_toggle_state
          end,
          set = function(state)
            local diag = require("tiny-inline-diagnostic.diagnostic")
            if state then
              diag.enable()
            else
              diag.disable()
            end
          end,
        })
        :map("<leader>up")
    end,
  },
  {
    "Fildo7525/pretty_hover",
    event = "LspAttach",
    opts = {},
  },
  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>c", "", desc = "+lsp", mode = { "n", "x" } },
    },
    dependencies = {
      "saghen/blink.cmp",
      "nvim-telescope/telescope.nvim",
      "b0o/schemastore.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "yioneko/nvim-vtsls",
        lazy = true,
        init = function()
          local loaded = false
          local function check()
            local result = vim.fs.root(0, { "tsconfig.json" })

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
            "gro",
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
            "gru",
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
          {
            "grU",
            function()
              require("vtsls").commands.remove_unused(0)
            end,
            desc = "Remove unused",
          },
        },
      },
      {
        -- "zbirenbaum/neodim",
        "ALVAROPING1/neodim",
        enabled = false,
        branch = "fix-nvim-0.11",
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
        "luckasRanarison/tailwind-tools.nvim",
        enabled = false,
        event = "VeryLazy",
        dependencies = {
          "nvim-treesitter/nvim-treesitter",
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

      -- lsp.eslint.setup({ capabilities = capabilities })
      vim.lsp.config("eslint", {
        settings = {
          format = { enable = false },
          rulesCustomizations = { { rule = "*", severity = "warn" } },
        },
      })
      vim.lsp.enable("eslint")
      -- lsp.relay.setup({  capabilities = capabilities })
      vim.lsp.config("tailwindcss", {
        -- capabilities = capabilities,
        settings = {
          classAttributes = { "class", "className", "class:list", "classList", "ngClass", "classes" },
        },
      })
      vim.lsp.enable("tailwindcss")

      vim.lsp.enable("taplo")
      vim.lsp.enable("yamlls")
      vim.lsp.enable("zls")
      vim.lsp.config("herb_ls", {
        settings = {
          languageServerHerb = {
            formatter = {
              enabled = true,
              indentWidth = 2,
              maxLineLength = 100,
            },
            linter = {
              enabled = true,
              fixOnSave = false,
            },
          },
        },
        init_options = {
          enabledFeatures = {
            diagnostics = true,
          },
          experimentalFeaturesEnabled = true,
        },
      })
      vim.lsp.enable("herb_ls")

      -- lsp.taplo.setup({ capabilities = capabilities })
      -- lsp.yamlls.setup({ capabilities = capabilities })
      -- lsp.zls.setup({ capabilities = capabilities })
      lsp.lua.setup({ capabilities = capabilities })

      vim.lsp.enable("markdown_oxide")
      -- lsp.markdown_oxide.setup({
      --
      --   capabilities = capabilities,
      -- })

      vim.lsp.enable("ruff")
      -- lsp.ruff.setup({
      --   capabilities = capabilities,
      -- })
      --
      vim.lsp.config("basedpyright", {
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
      vim.lsp.enable("basedpyright")

      -- lsp.vectorcode_server.setup({ capabilities = capabilities })

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
      vim.lsp.config("biome", {
        filetypes = { "typescript", "typescriptreact" },
      })
      vim.lsp.enable("biome")

      -- lsp.html.setup({ capabilities = capabilities })
      vim.lsp.enable("html")
      -- lsp.htmx.setup({ capabilities = capabilities, filetypes = { "html", "templ", "eruby" } })
      -- lsp.sourcekit.setup({ capabilities = capabilities })
      vim.lsp.enable("sourcekit")
      -- lsp.theme_check.setup({ capabilities = capabilities })
      vim.lsp.config("typos_lsp", {
        init_options = {
          diagnosticSeverity = "Warning",
        },
      })
      vim.lsp.enable("typos_lsp")

      vim.lsp.inline_completion.enable()
      vim.lsp.config("copilot", {
        settings = {
          telemetry = {
            telemetryLevel = "off",
          },
        },
      })
      vim.lsp.enable("copilot")
      -- lsp.harper_ls.setup({
      --   capabilities = capabilities,
      --   filetypes = { "modelfile", "markdown" },
      --   settings = {
      --     ["harper-ls"] = {
      --       diagnosticSeverity = "hint",
      --       linters = {
      --         SpellCheck = true,
      --         SpelledNumbers = false,
      --         AnA = true,
      --         SentenceCapitalization = false,
      --         UnclosedQuotes = true,
      --         WrongQuotes = false,
      --         LongSentences = true,
      --         RepeatedWords = true,
      --         Spaces = true,
      --         Matcher = true,
      --         CorrectNumberSuffix = true,
      --         NumberSuffixCapitalization = true,
      --         MultipleSequentialPronouns = true,
      --         LinkingVerbs = false,
      --         AvoidCurses = false,
      --         ToDoHyphen = false,
      --       },
      --     },
      --   },
      -- })

      -- Workaround for truncating long TypeScript inlay hints.
      -- TODO: Remove this if https://github.com/neovim/neovim/issues/27240 gets addressed.
      -- local inlay_hint_handler = vim.lsp.handlers[Methods.textDocument_inlayHint]
      -- vim.lsp.handlers[Methods.textDocument_inlayHint] = function(err, result, ctx, config)
      --   local client = vim.lsp.get_client_by_id(ctx.client_id)
      --   if client and client.name == "vtsls" then
      --     result = vim.iter(result):map(function(hint)
      --       if type(hint.label) == "string" then
      --         local label = hint.label ---@type string
      --         if string.len(label) >= 30 then
      --           label = label:sub(1, 29) .. "…"
      --         end
      --         hint.label = label
      --       end
      --       return hint
      --     end)
      --   end
      --
      --   inlay_hint_handler(err, result, ctx, config)
      -- end
      vim.lsp.config("vtsls", {
        root_markers = { "tsconfig.json", "jsconfig.json" },
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
            suggest = { completeFunctionCalls = true },
          },
          vtsls = {
            experimental = {
              completion = {
                enableServerSideFuzzyMatch = true,
              },
            },
          },
        },
      })
      vim.lsp.enable("vtsls")

      vim.lsp.config("denols", {
        root_markers = { "deno.json", "deno.jsonc" },
      })
      -- vim.lsp.enable("denols")

      vim.lsp.config("sqruff", {
        root_markers = { ".sqruff" },
      })
      vim.lsp.enable("sqruff")

      vim.lsp.enable("gdscript")

      vim.lsp.enable("ast_grep")

      local function hover()
        local filetype = vim.filetype.match({ buf = 0 })
        if vim.tbl_contains({ "vim", "help" }, filetype) then
          vim.cmd("h " .. vim.fn.expand("<cword>"))
        elseif vim.tbl_contains({ "man" }, filetype) then
          vim.cmd("Man " .. vim.fn.expand("<cword>"))
        elseif vim.fn.expand("%:t") == "Cargo.toml" then
          require("crates").show_popup()
        else
          -- vim.lsp.buf.hover()
          require("pretty_hover").hover()
        end
      end

      -- legendary.keymap({
      --   "<Leader>a",
      --   function()
      --     require("actions-preview").code_actions()
      --   end,
      --   modes = { "n", "x" },
      --   opts = { silent = true, desc = "Select a code action" },
      -- })

      set("i", "<C-y>", function()
        if not vim.lsp.inline_completion.get() then
          return "<C-y>"
        end
      end, { expr = true, desc = "Accept the current inline completion" })

      set({ "n", "x" }, "<CR>", function()
        if not vim.lsp.buf.selection_range(1) then
          return "<CR>"
        end
      end, { expr = true, desc = "Expand selection range" })

      set({ "n", "x" }, "<BS>", function()
        if not vim.lsp.buf.selection_range(-1) then
          return "<BS>"
        end
      end, { expr = true, desc = "Shrink selection range" })

      -- set({ "n", "x" }, "<leader>ca", require("actions-preview").code_actions, { desc = "Select a code action" })
      set({ "n", "x" }, "gra", require("tiny-code-action").code_action, { desc = "Select a code action" })
      -- set({ "n", "x" }, "<leader>cl", vim.lsp.codelens.run, { desc = "Run Code Lens" })
      set({ "n", "x" }, "grl", vim.lsp.codelens.run, { desc = "Run Code Lens" })

      set("n", "gd", function()
        Snacks.picker.lsp_definitions()
      end, { silent = true, desc = "Go to definition" })

      set("n", "grr", function()
        Snacks.picker.lsp_references()
      end, { desc = "Go to references" })

      set("n", "<leader>gs", function()
        Snacks.picker.git_status()
      end, { desc = "Git Status" })

      set("n", "gri", function()
        Snacks.picker.lsp_implementations()
      end, { desc = "Go to Implementation" })

      set("n", "gry", function()
        Snacks.picker.lsp_type_definitions()
      end, { desc = "Goto T[y]pe Definition" })

      -- set("n", "L", function()
      --   vim.diagnostic.open_float(nil, {
      --     scope = "line",
      --     show_header = false,
      --     source = "always",
      --     focusable = false,
      --     border = "rounded",
      --   })
      -- end, { silent = true, desc = "Show diagnostics on current line" })

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
