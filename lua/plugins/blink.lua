return {
  {
    "onsails/lspkind-nvim",
    lazy = true,
  },
  {
    "saghen/blink.cmp",
    lazy = false,
    version = "*",
    dependencies = {
      "rafamadriz/friendly-snippets",
      { "xzbdmw/colorful-menu.nvim", opts = {} },
      {
        "saghen/blink.compat",
        optional = true,
        opts = {},
      },
      { "disrupted/blink-cmp-conventional-commits" },
    },
    -- build = "cargo build --release",
    opts_extend = {
      "sources.completion.enabled_providers",
      "sources.compat",
      "sources.default",
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      enabled = function()
        return not vim.tbl_contains({ "TelescopePrompt" }, vim.bo.filetype)
          and vim.bo.buftype ~= "prompt"
          and vim.b.completion ~= false
      end,
      fuzzy = {
        implementation = "prefer_rust_with_warning",
        prebuilt_binaries = {
          download = true,
        },
        -- sorts = {
        --   "exact",
        --   -- defaults
        --   "score",
        --   "sort_text",
        -- },
      },
      keymap = {
        preset = "super-tab",
        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "cancel", "fallback" },
        ["<S-Tab>"] = { "select_prev", "fallback" },
        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_next({ on_ghost_text = true })
            end
          end,
          "fallback",
        },
        ["<C-y>"] = {
          function(cmp)
            if cmp.is_ghost_text_visible() then
              return cmp.select_next({ on_ghost_text = true })
            end
          end,
          "fallback",
        },
      },
      completion = {
        accept = {
          auto_brackets = { enabled = true },
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = false,
          },
        },
        menu = {
          border = "rounded",
          draw = {
            -- columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind", "source_name", gap = 1 } },
            columns = { { "label" }, { "kind_icon", "kind", "source_name", gap = 1 } },
            treesitter = { "lsp" },
            components = {
              label = {
                text = function(ctx)
                  return require("colorful-menu").blink_components_text(ctx)
                end,
                highlight = function(ctx)
                  return require("colorful-menu").blink_components_highlight(ctx)
                end,
              },
            },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 0,
          window = {
            border = "rounded",
          },
        },
        ghost_text = {
          enabled = false,
          show_without_menu = false,
          show_with_menu = false,
        },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      signature = {
        enabled = true,
        window = {
          border = "rounded",
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        per_filetype = { gitcommit = { "conventional_commits" } },
        providers = {
          conventional_commits = {
            name = "Conventional Commits",
            module = "blink-cmp-conventional-commits",
            enabled = function()
              return vim.bo.filetype == "gitcommit"
            end,
            ---@module 'blink-cmp-conventional-commits'
            ---@type blink-cmp-conventional-commits.Options
            opts = {}, -- none so far
          },
        },
      },

      cmdline = {
        keymap = {
          preset = "inherit",
        },
        completion = {
          list = {
            selection = {
              preselect = false,
              auto_insert = false,
            },
          },
          menu = {
            auto_show = true,
          },
        },
      },
      term = {
        enabled = true,
      },
    },
  },
}
