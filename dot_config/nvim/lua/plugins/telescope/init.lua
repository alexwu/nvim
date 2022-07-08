local extensions = require("telescope").extensions
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_pickers = require("plugins.telescope.pickers")
local autocmd = vim.api.nvim_create_autocmd
local lazy = require("bombeelu.utils").lazy
local set = require("bombeelu.utils").set
local mk_repeatable = require("bombeelu.repeat").mk_repeatable

require("telescope").setup({
  defaults = {
    set_env = { ["COLORTERM"] = "truecolor" },
    prompt_prefix = "❯ ",
    layout_config = {
      width = function()
        return math.max(100, vim.fn.round(vim.o.columns * 0.5))
      end,
    },
    sorting_strategy = "ascending",
    layout_strategy = "center",
    dynamic_preview_title = true,
    winblend = 10,
    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
        ["<C-u>"] = false,
      },
      n = {
        ["q"] = actions.close,
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
      },
    },
  },
  pickers = {
    find_files = {
      find_command = {
        "fd",
        "--type",
        "f",
        "--strip-cwd-prefix",
        "--exclude",
        ".git",
        "--hidden",
        "--exclude",
        ".DS_Store",
        "--exclude",
        ".keep",
      },
      follow = true,
      hidden = true,
      no_ignore = false,
    },
    fd = {
      find_command = {
        "fd",
        "--type",
        "f",
        "--strip-cwd-prefix",
        "--exclude",
        ".git",
        "--hidden",
        "--exclude",
        ".DS_Store",
        "--exclude",
        ".keep",
      },
      follow = true,
      hidden = true,
      no_ignore = false,
    },
    buffers = {
      initial_mode = "normal",
      ignore_current_buffer = true,
      cwd_only = true,
      sort_lastused = true,
      path_display = function(opts, path)
        local tail = require("telescope.utils").path_tail(path)
        return string.format("%s (%s)", tail, path)
      end,
      mappings = {
        n = {
          ["<leader><space>"] = actions.close,
        },
      },
    },
    jumplist = {
      show_line = false,
      trim_text = true,
      path_display = function(opts, path)
        local tail = require("telescope.utils").path_tail(path)
        return string.format("%s (%s)", tail, path)
      end,
    },
    lsp_definitions = {
      initial_mode = "normal",
    },
    lsp_references = {
      initial_mode = "normal",
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    project = {
      base_dirs = {
        "~/Code",
        "~/Projects",
      },
      hidden_files = true,
      load_session = true,
    },
    commander = {},
  },
})

require("telescope").load_extension("fzf")
-- require("telescope").load_extension("commander")
require("telescope").load_extension("related_files")

require("neoclip").setup({
  enable_persistent_history = true,
})

set("n", { "<Leader><space>", "<Leader>b" }, lazy(builtin.buffers), { desc = "Select an open buffer" })

set("n", { "<D-p>", "<C-S-P>" }, lazy(extensions.commander.commander), { desc = "Select command" })

-- extensions.commander.favorites({
--   favorites = {
--     {
--       title = "Find Files",
--       callback = lazy(custom_pickers.project_files),
--       description = "Select files from current directory",
--     },
--     {
--       title = "Buffers",
--       callback = function()
--         custom_pickers.buffers({
--           initial_mode = "normal",
--           ignore_current_buffer = true,
--           only_cwd = true,
--           sort_lastused = true,
--           path_display = { "smart" },
--         })
--       end,
--     },
--     {
--       title = "Projects",
--       callback = extensions.project.project,
--       description = "Select a project",
--     },
--     {
--       title = "LSP Document Symbols",
--       callback = builtin.lsp_document_symbols,
--       description = "Select a document symbol from LSP",
--     },
--     {
--       title = "Clipboard History",
--       callback = extensions.neoclip.default,
--       description = "Select from clipboard history",
--     },
--     {
--       title = "Live Grep",
--       callback = builtin.live_grep,
--       description = "Grep the current directory",
--     },
--     {
--       title = "Snippets",
--       callback = custom_pickers.snippets,
--       description = "Select snippet based on current file",
--     },
--     {
--       title = "Todo",
--       callback = extensions["todo-comments"],
--       description = "Select a todo from the current directory",
--     },
--   },
-- })

set("n", "<Leader>f", lazy(builtin.find_files, { prompt_title = "Find Files" }), { desc = "Select files" })
set("n", "<Leader>d", lazy(builtin.diagnostics), { desc = "Select diagnostics " })
set("n", "<Leader>g", lazy(custom_pickers.git_changes), { desc = "Select from changed files since default branch" })
set("n", "<Leader>i", lazy(extensions.related_files.related_files), { desc = "Select related files" })
set("n", "<Leader>p", lazy(extensions.projects.projects), { noremap = true, silent = true, desc = "Select a project" })

autocmd("FileType", { pattern = "TelescopePrompt", command = "setlocal nocursorline" })
vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
