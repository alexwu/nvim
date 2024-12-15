if true then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = "Copilot",
    build = ":Copilot auth",
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
      copilot_node_command = "/opt/homebrew/bin/node",
    },
  },
  { "rafamadriz/friendly-snippets" },
  {
    "hrsh7th/cmp-nvim-lsp",
    enabled = false,
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
    enabled = false,
    dependencies = { "nvim-telescope/telescope.nvim", "garymjr/nvim-snippets" },
    opts = {
      snippetDir = vim.fn.stdpath("config") .. "/snippets",
    },
  },
  {
    -- "hrsh7th/nvim-cmp",
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
    event = "InsertEnter",
    dependencies = {
      {
        "iguanacucumber/mag-nvim-lsp",
        name = "cmp-nvim-lsp",
        opts = {},
        enabled = false,
      },
      -- { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      {
        "iguanacucumber/mag-buffer",
        name = "cmp-buffer",
      },
      { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },
      "nvim-lua/plenary.nvim",
      "onsails/lspkind-nvim",
      "https://codeberg.org/FelipeLema/cmp-async-path",
      { "tzachar/cmp-tabnine", build = "./install.sh" },
      {
        "zbirenbaum/copilot-cmp",
        enabled = true,
        dependencies = { "copilot.lua" },
        opts = {},
      },
      {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        enabled = true,
        dependencies = {
          -- "hrsh7th/nvim-cmp",
          -- "iguanacucumber/magazine.nvim",
          -- "iguanacucumber/mag-nvim-lsp",
        },
        config = function()
          require("tailwindcss-colorizer-cmp").setup({})
        end,
      },
      {
        "Exafunction/codeium.nvim",
        enabled = false,
        cmd = "Codeium",
        build = ":Codeium Auth",
        opts = {
          enable_chat = true,
        },
      },
      {
        "petertriho/cmp-git",
        dependencies = {
          -- "hrsh7th/nvim-cmp",
          -- "iguanacucumber/magazine.nvim",
        },
        opts = {},
      },
    },
    opts = function()
      local cmp = require("cmp")
      local mapping = cmp.mapping
      local compare = cmp.config.compare
      local Config = require("lazy.core.config")

      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local tab_next = function(fallback)
        if cmp.visible() then
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

      ---@param entry cmp.Entry
      ---@param vim_item any
      ---@return any
      local function before_callback(entry, vim_item)
        if Config.plugins["tailwind-tools"] then
        end
        return require("tailwind-tools.cmp").lspkind_format(entry, vim_item)
      end

      return {
        sources = cmp.config.sources({
          { name = "git" },
          {
            name = "nvim_lsp",
            max_item_count = 5,
            -- entry_filter = function(entry, ctx)
            --   local label = entry:get_completion_item().label
            --   local sorbet_type_warning = "(file is not `# typed: true` or higher)"
            --   return not vim.endswith(label, sorbet_type_warning)
            -- end,
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
          {
            name = "cmp_tabnine",
            max_item_count = 2,
          },
          -- {
          --   name = "codeium",
          --   max_item_count = 2,
          -- },
          { name = "copilot", max_item_count = 2 },
          { name = "async_path" },
        }),
        comparators = {
          compare.locality,
          compare.exact,
          compare.offset,
          compare.score,
          -- require("cmp_tabnine.compare"),
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
          ["<Tab>"] = mapping(select_next),
          ["<S-Tab>"] = mapping(select_prev),
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
              before = before_callback,
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
                codeium = "[AI]",
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
      local Config = require("lazy.core.config")

      cmp.setup(opts)

      ---@param entry cmp.Entry
      ---@param vim_item any
      ---@return any
      local function before_callback(entry, vim_item)
        return require("tailwind-tools.cmp").lspkind_format(entry, vim_item)
      end

      local preset = function()
        if vim.env.TERM_PROGRAM == "iTerm.app" or vim.g.neovide then
          return "default"
        else
          return "codicons"
        end
      end

      cmp.setup.cmdline({ "/", "?" }, {
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
          { name = "async_path" },
        },
        formatting = {
          format = function(entry, vim_item)
            return require("lspkind").cmp_format({
              before = before_callback,
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
                codeium = "[AI]",
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
          { name = "async_path" },
        }, {
          { name = "cmdline" },
        }),
      })

      cmp.setup.filetype("oil", {
        sources = cmp.config.sources({
          { name = "buffer" },
          { name = "async_path" },
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

      if Config.plugins["cmp-tabnine"] then
        local prefetch = vim.api.nvim_create_augroup("prefetch", { clear = true })

        vim.api.nvim_create_autocmd("BufRead", {
          group = prefetch,
          pattern = "*",
          callback = function()
            require("cmp_tabnine"):prefetch(vim.fn.expand("%:p"))
          end,
        })
      end
    end,
  },
}
