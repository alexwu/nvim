local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang

return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    -- commit = "56c63529c052a179134842c56c6df5728cc375da",
    -- tag = "v0.9.0",
    dependencies = {
      -- "nvim-treesitter/nvim-treesitter-refactor",
      "RRethy/nvim-treesitter-textsubjects",
      "RRethy/nvim-treesitter-endwise",
      "JoosepAlviste/nvim-ts-context-commentstring",
      "windwp/nvim-autopairs",
      "windwp/nvim-ts-autotag",
      "nvim-treesitter/playground",
      "andymass/vim-matchup",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
          -- enable = not vim.g.vscode,
          -- additional_vim_regex_highlighting = { "ruby" },
          -- disable = { "lua" },
        },
        indent = {
          enable = not vim.g.vscode,
          -- disable = { "lua" }
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
          },
        },
        textsubjects = {
          enable = true,
          prev_selection = "<BS>",
          keymaps = {
            ["<CR>"] = "textsubjects-smart",
            [";"] = "textsubjects-container-outer",
          },
        },
        endwise = {
          enable = true,
        },
        playground = {
          enable = true,
          disable = {},
          updatetime = 25,
          persist_queries = true,
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        -- refactor = {
        --   smart_rename = {
        --     enable = true,
        --     keymaps = {
        --       smart_rename = "gsn",
        --     },
        --   },
        --   navigation = {
        --     enable = false,
        --     keymaps = {
        --       goto_definition_lsp_fallback = "gd",
        --     },
        --   },
        --   highlight_current_scope = { enable = false },
        --   highlight_definitions = {
        --     enable = false,
        --     clear_on_cursor_move = false,
        --   },
        -- },
        autopairs = { enable = true },
        autotag = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        matchup = {
          enable = false,
        },
        -- highlight_current_node = {
        --   enable = true,
        --   excluded_filetypes = { "help" },
        -- },
      })

      require("nvim-treesitter.parsers").ft_to_lang = function(ft)
        if ft == "zsh" then
          return "bash"
        end
        return ft_to_lang(ft)
      end

      -- require("nvim-treesitter.parsers").get_parser_configs().just = {
      --   install_info = {
      --     url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
      --     files = { "src/parser.c", "src/scanner.cc" },
      --     branch = "main",
      --   },
      --   maintainers = { "@IndianBoy42" },
      -- }

      -- require("bombeelu.treesitter").init()
    end,
  },
  {
    "Wansmer/treesj",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = { "<space>m", "<space>j", "<space>s" },
    opts = {
      max_join_length = 200,
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    enabled = true,
    config = function()
      require("treesitter-context").setup({
        enabled = true,
        max_lines = 3,
        trim_scope = "outer",
        patterns = {
          default = {
            "class",
            "function",
            "method",
            "for",
            "while",
            "if",
            "switch",
            "case",
          },
        },
        zindex = 41,
      })

      vim.keymap.set("n", "[C", function()
        require("treesitter-context").go_to_context()
      end, { silent = true })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
              ["ab"] = "@block.outer",
              ["ib"] = "@block.inner",
              ["a?"] = "@block.outer",
              ["i?"] = "@block.inner",
            },
          },
        },
      })
    end,
  },
  {
    "aarondiel/spread.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      local spread = require("spread")
      local default_options = { silent = true, noremap = true }

      vim.keymap.set("n", "gS", spread.out, default_options)
      vim.keymap.set("n", "gJ", spread.combine, default_options)
    end,
    enabled = false,
  },
  {
    "windwp/nvim-ts-autotag",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cond = function()
      return not vim.g.vscode
    end,
  },
  {
    "ziontee113/syntax-tree-surfer",
    event = "VeryLazy",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("bombeelu.syntax-tree-surfer").setup()
    end,
  },
}
