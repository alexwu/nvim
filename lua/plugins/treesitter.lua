return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
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
        },
        indent = {
          enable = not vim.g.vscode,
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
        autopairs = { enable = true },
        autotag = { enable = true },
        context_commentstring = { enable = true, enable_autocmd = false },
        matchup = {
          enable = true,
        },
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

      set("n", "[C", function()
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
    opts = {},
    keys = {
      {
        "vD",
        function()
          vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
          return "g@l"
        end,
        desc = "Swap treesitter node with the node below",
        silent = true,
        expr = true,
      },
      {
        "vU",
        function()
          vim.opt.opfunc = "v:lua.STSSwapUpNormal_Dot"
          return "g@l"
        end,
        desc = "Swap treesitter node with the node above",
        silent = true,
        expr = true,
      },
      {
        "vd",
        function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
          return "g@l"
        end,
        silent = true,
        expr = true,
        desc = "Swap treesitter node with the next node",
      },
      {
        "vu",
        function()
          vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
          return "g@l"
        end,
        silent = true,
        expr = true,
        desc = "Swap treesitter node with the previous node",
      },
    },
  },
}
