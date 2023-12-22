return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
    end,
    event = { "BufReadPost", "BufNewFile" },
    dependencies = {
      "RRethy/nvim-treesitter-textsubjects",
      "RRethy/nvim-treesitter-endwise",
      "windwp/nvim-autopairs",
      "windwp/nvim-ts-autotag",
      "andymass/vim-matchup",
    },
    config = function()
      require("nvim-treesitter.configs").setup({
        highlight = {
          enable = true,
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
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { "BufWrite", "CursorHold" },
        },
        autopairs = { enable = true },
        autotag = { enable = true },
        matchup = {
          enable = true,
        },
      })

      require("nvim-treesitter.parsers").get_parser_configs().just = {
        install_info = {
          url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
          files = { "src/parser.c", "src/scanner.cc" },
          branch = "main",
          use_makefile = true,
        },
        maintainers = { "@IndianBoy42" },
      }

      require("nvim-treesitter.parsers").get_parser_configs().nu = {
        install_info = {
          url = "https://github.com/nushell/tree-sitter-nu",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "nu",
      }

      -- NOTE: nu hightlights install snippet
      --  let remote = "https://raw.githubusercontent.com/nushell/tree-sitter-nu/main/queries/"
      -- let local = (
      --     $env.XDG_DATA_HOME?
      --     | default ($env.HOME | path join ".local" "share")
      --     | path join "nvim" "lazy" "nvim-treesitter" "queries" "nu"
      -- let file = "highlights.scm"
      -- mkdir $local
      -- http get ([$remote $file] | str join "/") | save --force ($local | path join $file)

      -- require("bombeelu.treesitter").init()
      require("bombeelu.i18n-parser").setup()
    end,
  },
  {
    "Wansmer/treesj",
    event = "VeryLazy",
    dependencies = { "mrjones2014/legendary.nvim", "echasnovski/mini.splitjoin" },
    opts = {
      ---@type number If line after join will be longer than max value, node will not be formatted
      max_join_length = 1000,
      ---@type boolean Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
      use_default_keymaps = false,
      ---@type boolean Node with syntax error will not be formatted
      check_syntax_error = true,
      ---@type 'hold'|'start'|'end'
      cursor_behavior = "hold",
      ---@type boolean Notify about possible problems or not
      notify = true,
      ---@type boolean Use `dot` for repeat action
      dot_repeat = true,
      ---@type nil|function Callback for treesj error handler. func (err_text, level, ...other_text)
      on_error = nil,
      ---@type table Presets for languages
    },
    config = function(_, opts)
      local tsj = require("treesj")

      local legendary = require("legendary")
      require("treesj").setup(opts)

      local langs = require("treesj.langs")["presets"]
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "*",
        callback = function()
          if langs[vim.bo.filetype] then
            -- vim.keymap.set("n", "gS", tsj.split, o)
            -- vim.keymap.set("n", "gJ", tsj.join, o)
            --
            legendary.keymaps({
              {
                "gS",
                function()
                  tsj.split()
                end,
                description = "Split lines (treesj)",
                opts = { buffer = true },
              },
              {
                "gJ",
                function()
                  tsj.join()
                end,
                description = "Join lines (treesj)",
                opts = { buffer = true },
              },
            })
          else
            -- vim.keymap.set("n", "gS", require("mini.splitjoin").split, o)
            -- vim.keymap.set("n", "gJ", require("mini.splitjoin").join, o)
            legendary.keymaps({
              {
                "gS",
                function()
                  require("mini.splitjoin").split()
                end,
                description = "Split lines (fallback)",
                opts = { buffer = true },
              },
              {
                "gJ",
                function()
                  require("mini.splitjoin").join()
                end,
                description = "Join lines (fallback)",
                opts = { buffer = true },
              },
            })
          end
        end,
      })
    end,
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
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    opts = {
      enable = true,
      enable_autocmd = false,
      config = {
        nu = "# %s",
      },
    },
    config = function(_, opts)
      require("ts_context_commentstring").setup(opts)
    end,
  },
}
