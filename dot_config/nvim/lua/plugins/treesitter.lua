require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "bash",
    "comment",
    "go",
    "graphql",
    "html",
    "http",
    "json",
    "json5",
    "jsonc",
    "lua",
    "python",
    "regex",
    "ruby",
    "rust",
    "swift",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "yaml",
  },
  highlight = { enable = true, additional_vim_regex_highlighting = false },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<CR>",
      -- node_incremental = "<C-s>",
      -- scope_incremental = "<C-a>",
      -- node_decremental = "grm",
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
      },
    },
  },
  playground = {
    enable = false,
    disable = {},
    updatetime = 25,
    persist_queries = false,
  },
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "<leader>rn",
      },
    },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition_lsp_fallback = "gd",
      },
    },
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  matchup = { enable = true },
}
