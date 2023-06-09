local ft_to_lang = require("nvim-treesitter.parsers").ft_to_lang

return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  commit = "ab3bf7d95615098f47596ab245282c03149195e7",
  dependencies = {
    "nvim-treesitter/nvim-treesitter-refactor",
    "RRethy/nvim-treesitter-textsubjects",
    "RRethy/nvim-treesitter-endwise",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "windwp/nvim-autopairs",
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/playground",
    "andymass/vim-matchup",
  },
  -- tag = "v0.9.0",
  config = function()
    require("nvim-treesitter.configs").setup({
      highlight = {
        enable = false,
        -- enable = not vim.g.vscode,
        additional_vim_regex_highlighting = { "ruby" },
        disable = { "lua", "comment", "bash" },
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
}
