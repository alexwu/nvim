return {
  {
    "hrsh7th/cmp-nvim-lsp",
    lazy = false,
  },
  {
    "onsails/lspkind-nvim",
    lazy = true,
  },
  {
    "garymjr/nvim-snippets",
    opts = {
      friendly_snippets = true,
      create_cmp_source = true,
    },
  },
  {
    "chrisgrieser/nvim-scissors",
    dependencies = { "nvim-telescope/telescope.nvim", "garymjr/nvim-snippets" },
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
    },
    keys = {
      {
        "<leader>se",
        function()
          require("scissors").editSnippet()
        end,
        desc = "Edit snippets",
      },
      {
        "<leader>sa",
        function()
          require("scissors").addNewSnippet()
        end,
        mode = { "n", "x" },
        desc = "Add new snippet",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    cond = function()
      return not vim.g.vscode
    end,
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "nvim-lua/plenary.nvim",
      "onsails/lspkind-nvim",
      { "tzachar/cmp-tabnine", build = "./install.sh" },
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        dependencies = { "hrsh7th/nvim-cmp" },
        config = function()
          require("tailwindcss-colorizer-cmp").setup({})
        end,
      },
      {
        "Exafunction/codeium.nvim",
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {},
        config = true,
      },
    },
    opts = function()
      local cmp = require("cmp")
      local mapping = cmp.mapping
      local compare = cmp.config.compare

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local tab_next = function(fallback)
        if cmp.visible() and has_words_before() then
          cmp.select_next_item()
        elseif vim.snippet.active({ direction = 1 }) then
          vim.snippet.jump(1)
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local tab_prev = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif vim.snippet.active({ direction = -1 }) then
          vim.snippet.jump(-1)
        else
          fallback()
        end
      end

      local select_next = function(fallback)
        if cmp.visible() then
          -- cmp.select_next_item()
          cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end

      local select_prev = function(fallback)
        if cmp.visible() then
          -- cmp.select_prev_item()
          cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
        else
          fallback()
        end
      end

      local preset = function()
        if vim.env.TERM_PROGRAM == "iTerm.app" or vim.g.neovide then
          return "default"
        else
          return "codicons"
        end
      end

      return {
        sources = cmp.config.sources({
          {
            name = "nvim_lsp",
            max_item_count = 20,
            entry_filter = function(entry, _ctx)
              local label = entry:get_completion_item().label
              local sorbet_type_warning = "(file is not `# typed: true` or higher)"
              return not vim.endswith(label, sorbet_type_warning)
            end,
          },
          { name = "snippets" },
          {
            name = "buffer",
            option = {
              get_bufnrs = function()
                local bufs = {}
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                  bufs[vim.api.nvim_win_get_buf(win)] = true
                end
                return vim.tbl_keys(bufs)
              end,
            },
          },
          { name = "cmp_tabnine" },
          {
            name = "codeium",
            max_item_count = 2,
          },
          { name = "path" },
        }),
        comparators = {
          compare.locality,
          compare.exact,
          compare.offset,
          compare.score,
          require("cmp_tabnine.compare"),
          compare.recently_used,
          compare.scopes,
          compare.kind,
          compare.length,
        },
        snippet = {
          expand = function(args)
            vim.snippet.expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered({ border = "rounded" }),
          documentation = cmp.config.window.bordered({ border = "rounded", winhighlight = "FloatBorder:FloatBorder" }),
        },
        mapping = mapping.preset.insert({
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<Down>"] = mapping(select_next),
          ["<Up>"] = mapping(select_prev),
          ["<C-e>"] = mapping({
            i = mapping.abort(),
            c = mapping.close(),
          }),
          ["<C-n>"] = mapping(select_next),
          ["<C-p>"] = mapping(select_prev),
          ["<Tab>"] = mapping(tab_next),
          ["<S-Tab>"] = mapping(tab_prev),
          ["<C-l>"] = mapping(function(fallback)
            if cmp.visible() then
              return cmp.complete_common_string()
            end
            fallback()
          end),
        }),
        formatting = {
          format = function(entry, vim_item)
            return require("lspkind").cmp_format({
              before = require("tailwind-tools.cmp").lspkind_format,
              preset = preset(),
              mode = "symbol_text",
              symbol_map = {
                Copilot = "",
                cmp_tabnine = "[]",
                Codeium = "",
              },
              menu = {
                buffer = "[Buffer]",
                nvim_lsp = "[LSP]",
                luasnip = "[LuaSnip]",
              },
              dup = {
                buffer = 0,
                path = 0,
                nvim_lsp = 1,
                cmp_tabnine = 0,
                treesitter = 0,
              },
            })(entry, vim_item)
          end,
        },
        experimental = {
          ghost_text = { highlight = "CmpGhostText" },
        },
      }
    end,
    config = function(_, opts)
      local cmp = require("cmp")
      local mapping = cmp.mapping
      local compare = cmp.config.compare

      -- local has_words_before = function()
      --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      --   return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      -- end
      --
      -- local tab_next = function(fallback)
      --   if cmp.visible() and has_words_before() then
      --     cmp.select_next_item()
      --   elseif vim.snippet.active({ direction = 1 }) then
      --     vim.snippet.jump(1)
      --   elseif has_words_before() then
      --     cmp.complete()
      --   else
      --     fallback()
      --   end
      -- end
      --
      -- local tab_prev = function(fallback)
      --   if cmp.visible() then
      --     cmp.select_prev_item()
      --   elseif vim.snippet.active({ direction = -1 }) then
      --     vim.snippet.jump(-1)
      --   else
      --     fallback()
      --   end
      -- end
      --
      -- local select_next = function(fallback)
      --   if cmp.visible() then
      --     -- cmp.select_next_item()
      --     cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
      --   elseif has_words_before() then
      --     cmp.complete()
      --   else
      --     fallback()
      --   end
      -- end
      --
      -- local select_prev = function(fallback)
      --   if cmp.visible() then
      --     -- cmp.select_prev_item()
      --     cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
      --   else
      --     fallback()
      --   end
      -- end
      --
      -- local preset = function()
      --   if vim.env.TERM_PROGRAM == "iTerm.app" or vim.g.neovide then
      --     return "default"
      --   else
      --     return "codicons"
      --   end
      -- end
      --
      -- cmp.setup({
      --   sources = cmp.config.sources({
      --     {
      --       name = "nvim_lsp",
      --       max_item_count = 20,
      --       entry_filter = function(entry, _ctx)
      --         local label = entry:get_completion_item().label
      --         local sorbet_type_warning = "(file is not `# typed: true` or higher)"
      --         return not vim.endswith(label, sorbet_type_warning)
      --       end,
      --     },
      --     { name = "snippets" },
      --     {
      --       name = "buffer",
      --       option = {
      --         get_bufnrs = function()
      --           local bufs = {}
      --           for _, win in ipairs(vim.api.nvim_list_wins()) do
      --             bufs[vim.api.nvim_win_get_buf(win)] = true
      --           end
      --           return vim.tbl_keys(bufs)
      --         end,
      --       },
      --     },
      --     { name = "cmp_tabnine" },
      --     { name = "path" },
      --   }),
      --   comparators = {
      --     compare.locality,
      --     compare.exact,
      --     compare.offset,
      --     compare.score,
      --     require("cmp_tabnine.compare"),
      --     compare.recently_used,
      --     compare.scopes,
      --     compare.kind,
      --     compare.length,
      --   },
      --   snippet = {
      --     expand = function(args)
      --       vim.snippet.expand(args.body)
      --     end,
      --   },
      --   window = {
      --     completion = cmp.config.window.bordered({ border = "rounded" }),
      --     documentation = cmp.config.window.bordered({ border = "rounded", winhighlight = "FloatBorder:FloatBorder" }),
      --   },
      --   mapping = mapping.preset.insert({
      --     ["<CR>"] = cmp.mapping.confirm({
      --       behavior = cmp.ConfirmBehavior.Replace,
      --       select = false,
      --     }),
      --     ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      --     ["<C-f>"] = cmp.mapping.scroll_docs(4),
      --     ["<Down>"] = mapping(select_next),
      --     ["<Up>"] = mapping(select_prev),
      --     ["<C-e>"] = mapping({
      --       i = mapping.abort(),
      --       c = mapping.close(),
      --     }),
      --     ["<C-n>"] = mapping(select_next),
      --     ["<C-p>"] = mapping(select_prev),
      --     ["<Tab>"] = mapping(tab_next),
      --     ["<S-Tab>"] = mapping(tab_prev),
      --     ["<C-l>"] = mapping(function(fallback)
      --       if cmp.visible() then
      --         return cmp.complete_common_string()
      --       end
      --       fallback()
      --     end),
      --   }),
      --   formatting = {
      --     format = function(entry, vim_item)
      --       return require("lspkind").cmp_format({
      --         before = require("tailwind-tools.cmp").lspkind_format,
      --         preset = preset(),
      --         mode = "symbol_text",
      --         symbol_map = {
      --           Copilot = "",
      --           cmp_tabnine = "[]",
      --         },
      --         menu = {
      --           buffer = "[Buffer]",
      --           nvim_lsp = "[LSP]",
      --           luasnip = "[LuaSnip]",
      --         },
      --         dup = {
      --           buffer = 0,
      --           path = 0,
      --           nvim_lsp = 1,
      --           cmp_tabnine = 0,
      --           treesitter = 0,
      --         },
      --       })(entry, vim_item)
      --     end,
      --   },
      --   experimental = {
      --     ghost_text = { highlight = "CmpGhostText" },
      --   },
      -- })

      cmp.setup(opts)

      cmp.setup.cmdline("/", {
        mapping = mapping.preset.cmdline({
          ["<Down>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          },
          ["<Up>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        }),
        sources = {
          { name = "buffer" },
          { name = "path" },
        },
      })

      cmp.setup.cmdline(":", {
        mapping = mapping.preset.cmdline({
          ["<Down>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              else
                fallback()
              end
            end,
          },
          ["<Up>"] = {
            c = function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              else
                fallback()
              end
            end,
          },
        }),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      nvim.create_augroup("bombeelu.cmp", { clear = true })
      nvim.create_autocmd("FileType", {
        pattern = "toml",
        group = "bombeelu.cmp",
        callback = function()
          require("cmp").setup.buffer({ sources = { { name = "crates" } } })
        end,
      })

      nvim.create_autocmd("FileType", {
        pattern = { "TelescopePrompt", "nucleo" },
        group = "bombeelu.cmp",
        callback = function()
          require("cmp").setup.buffer({ enabled = false })
        end,
      })

      local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })

      vim.api.nvim_create_autocmd("BufRead", {
        group = prefetch,
        pattern = "*",
        callback = function()
          require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
        end,
      })
    end,
  },
}
