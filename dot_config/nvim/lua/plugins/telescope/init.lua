local set = vim.keymap.set
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local custom_pickers = require("plugins.telescope.pickers")
local autocmd = vim.api.nvim_create_autocmd
local extensions = require("telescope").extensions

require("telescope").setup({
  defaults = {
    set_env = { ["COLORTERM"] = "truecolor" },
    prompt_prefix = "❯ ",
    layout_config = {
      width = function()
        return math.max(100, vim.fn.round(vim.o.columns * 0.3))
      end,
      -- height = function(_, _, max_lines)
      -- 	return math.min(max_lines, 20)
      -- end,
    },
    sorting_strategy = "ascending",
    layout_strategy = "center",
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
        "--follow",
        "-uu",
        "--strip-cwd-prefix",
      },
    },
    buffers = {
      initial_mode = "normal",
      ignore_current_buffer = true,
      sort_lastused = true,
      path_display = { "smart" },
      mappings = {
        n = {
          ["<leader><space>"] = actions.close,
        },
      },
    },
    lsp_references = {
      initial_mode = "normal",
    },
    lsp_definitions = {
      initial_mode = "normal",
    },
    lsp_document_symbols = {
      mappings = {
        i = {
          ["-"] = actions.close,
        },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({
        layout_config = {
          width = function()
            return math.max(100, vim.fn.round(vim.o.columns * 0.3))
          end,
          height = function(_, _, max_lines)
            return math.min(max_lines, 15)
          end,
        },
      }),
    },
    project = {
      base_dirs = {},
      hidden_files = true,
    },
  },
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("ui-select")

require("neoclip").setup({
  enable_persistent_history = true,
})

set("n", "<Leader><space>", function()
  custom_pickers.buffers({
    initial_mode = "normal",
    ignore_current_buffer = true,
    only_cwd = true,
    sort_lastused = true,
    path_display = { "smart" },
    mappings = {
      n = {
        ["<leader><space>"] = actions.close,
      },
    },
  })
end, { desc = "Opens buffer switcher, auto-jumps if there's only one buffer" })

-- set("n", "<C-P>", function()
set("n", "<A-BSlash>", function()
  require("plugins.telescope.pickers").favorites({
    favorites = {
      { name = "Fuzzy Finder", callback = custom_pickers.project_files },
      {
        name = "Projects",
        callback = function()
          extensions.project.project({
            initial_mode = "normal",
          })
        end,
      },
      -- TODO: There's a delay if the LSP hasn't launched yet I think? Maybe add a loading thing
      {
        name = "LSP Document Symbols",
        callback = builtin.lsp_document_symbols,
      },
      {
        name = "Clipboard History",
        callback = extensions.neoclip.default,
      },
      {
        name = "Live Grep",
        callback = builtin.live_grep,
      },
      {
        name = "Snippets",
        callback = extensions.luasnip.luasnip(),
      },
    },
  })
  -- vim.ui.select({
  -- 	{ name = "Fuzzy Finder", callback = custom_pickers.project_files },
  -- 	{
  -- 		name = "Projects",
  -- 		callback = function()
  -- 			require("telescope").extensions.project.project({
  -- 				initial_mode = "normal",
  -- 			})
  -- 		end,
  -- 	},
  -- 	-- TODO: There's a delay if the LSP hasn't launched yet I think? Maybe add a loading thing
  -- 	{
  -- 		name = "LSP Document Symbols",
  -- 		callback = builtin.lsp_document_symbols,
  -- 	},
  -- 	{
  -- 		name = "Clipboard History",
  -- 		callback = require("telescope").extensions.neoclip.default,
  -- 	},
  -- 	{
  -- 		name = "Live Grep",
  -- 		callback = builtin.live_grep,
  -- 	},
  -- }, {
  -- 	prompt = "Command Palette",
  -- 	format_item = function(item)
  -- 		return item.name
  -- 	end,
  -- }, function(choice)
  -- 	if choice then
  -- 		choice.callback()
  -- 	end
  -- end)
end)

set("n", "<Leader>f", function()
  require("plugins.telescope.pickers").project_files({ prompt_title = "Fuzzy Finder" })
end)

set("n", "<Leader>td", function()
  builtin.diagnostics()
end)

set("n", "gag", function()
  builtin.live_grep()
end)

set("n", "gbr", function()
  builtin.git_branches()
end)

set("n", "<Leader>sn", function()
  require("plugins.telescope.pickers").snippets()
end)

set("n", "<Leader>st", function()
  builtin.git_status()
end)

set("n", "<Leader>i", function()
  require("plugins.telescope.pickers").related_files()
end)

set("n", "gp", function()
  require("telescope").extensions.neoclip.default()
end)

set("n", "<Leader>p", function()
  require("telescope").extensions.project.project({})
end, { noremap = true, silent = true })

set("n", "<BSlash>s", function()
  builtin.grep_string()
end, { noremap = true, silent = true })

autocmd("FileType", { pattern = "TelescopePrompt", command = "setlocal nocursorline" })

vim.cmd([[autocmd User TelescopePreviewerLoaded setlocal wrap]])
