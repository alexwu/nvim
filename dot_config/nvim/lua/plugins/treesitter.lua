local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang

require("bombeelu.treesitter").init()

require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "bash",
    "c",
    "comment",
    "cpp",
    "go",
    "graphql",
    "help",
    "html",
    "http",
    "java",
    "javascript",
    "json",
    "json5",
    "jsonc",
    "kotlin",
    "llvm",
    "lua",
    "python",
    "regex",
    "ruby",
    "rust",
    "scss",
    "svelte",
    "swift",
    "teal",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml",
  },
  highlight = { enable = not vim.g.vscode, additional_vim_regex_highlighting = false },
  indent = { enable = not vim.g.vscode },
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
  refactor = {
    smart_rename = {
      enable = true,
      keymaps = {
        smart_rename = "gsn",
      },
    },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition_lsp_fallback = "gd",
      },
    },
    highlight_current_scope = { enable = false },
    highlight_definitions = {
      enable = false,
      -- Set to false if you have an `updatetime` of ~100.
      clear_on_cursor_move = false,
    },
  },
  autopairs = { enable = true },
  autotag = { enable = true },
  context_commentstring = { enable = true, enable_autocmd = false },
  matchup = { enable = true },
  highlight_current_node = {
    enable = true,
  },
})

require("nvim-treesitter.parsers").ft_to_lang = function(ft)
  if ft == "zsh" then
    return "bash"
  end
  return ft_to_lang(ft)
end
