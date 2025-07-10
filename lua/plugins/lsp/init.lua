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
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    keys = {
      { "<leader>c", "", desc = "+lsp", mode = { "n", "x" } },
    },
    dependencies = {
      {
        -- NOTE: This needs to be at the top
        "folke/neoconf.nvim",
        enabled = false,
        module = "neoconf",
        config = true,
        opts = {},
      },
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
        "luckasRanarison/tailwind-tools.nvim",
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

      lsp.eslint.setup({ capabilities = capabilities })
      lsp.json.setup({ capabilities = capabilities })
      -- lsp.relay.setup({  capabilities = capabilities })
      lsp.tailwindcss.setup({
        capabilities = capabilities,
        settings = {
          classAttributes = { "class", "className", "class:list", "classList", "ngClass", "classes" },
        },
      })
      lsp.taplo.setup({ capabilities = capabilities })
      lsp.yamlls.setup({ capabilities = capabilities })
      lsp.zls.setup({ capabilities = capabilities })
      lsp.lua.setup({ capabilities = capabilities })

      lsp.markdown_oxide.setup({

        capabilities = capabilities,
      })

      lsp.ruff.setup({
        capabilities = capabilities,
      })

      lsp.basedpyright.setup({
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
      lsp.biome.setup({
        capabilities = capabilities,
        filetypes = { "typescript", "typescriptreact" },
      })
      lsp.html.setup({ capabilities = capabilities })
      -- lsp.htmx.setup({ capabilities = capabilities, filetypes = { "html", "templ", "eruby" } })
      lsp.sourcekit.setup({ capabilities = capabilities })
      lsp.theme_check.setup({ capabilities = capabilities })
      lsp.typos_lsp.setup({
        capabilities = capabilities,
        init_options = {
          -- Custom config. Used together with a config file found in the workspace or its parents,
          -- taking precedence for settings declared in both.
          -- Equivalent to the typos `--config` cli argument.
          -- config = "~/code/typos-lsp/crates/typos-lsp/tests/typos.toml",
          -- How typos are rendered in the editor, can be one of an Error, Warning, Info, or Hint.
          -- Defaults to error.
          diagnosticSeverity = "Warning",
        },
      })
      lsp.harper_ls.setup({

        capabilities = capabilities,
        filetypes = { "modelfile", "markdown" },
        settings = {
          ["harper-ls"] = {
            diagnosticSeverity = "hint",
            linters = {
              SpellCheck = true,
              SpelledNumbers = false,
              AnA = true,
              SentenceCapitalization = false,
              UnclosedQuotes = true,
              WrongQuotes = false,
              LongSentences = true,
              RepeatedWords = true,
              Spaces = true,
              Matcher = true,
              CorrectNumberSuffix = true,
              NumberSuffixCapitalization = true,
              MultipleSequentialPronouns = true,
              LinkingVerbs = false,
              AvoidCurses = false,
              ToDoHyphen = false,
            },
          },
        },
      })

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

      lsp.vtsls.setup({
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

      lsp.gdscript.setup({ capabilities = capabilities })

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

      -- legendary.keymap({
      --   "<Leader>a",
      --   function()
      --     require("actions-preview").code_actions()
      --   end,
      --   modes = { "n", "x" },
      --   opts = { silent = true, desc = "Select a code action" },
      -- })

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
