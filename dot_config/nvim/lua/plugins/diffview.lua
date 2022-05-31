local cb = require("diffview.config").diffview_callback
local tree_width = require("utils").tree_width

require("diffview").setup({
  diff_binaries = false,
  use_icons = true,
  file_panel = {
    win_config = {
      width = tree_width(0.2),
    },
    listing_style = "tree",
    tree_options = {
      flatten_dirs = true,
    },
  },
  enhanced_diff_hl = true,
  key_bindings = {
    view = {
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["<leader>e"] = cb("focus_files"),
      ["<leader>b"] = cb("toggle_files"),
      ["q"] = cb("close"),
      ["gf"] = cb("goto_file_edit"),
    },
    file_panel = {
      ["j"] = cb("next_entry"),
      ["<down>"] = cb("next_entry"),
      ["k"] = cb("prev_entry"),
      ["<up>"] = cb("prev_entry"),
      ["<cr>"] = cb("select_entry"),
      ["o"] = cb("select_entry"),
      ["R"] = cb("refresh_files"),
      ["<tab>"] = cb("select_next_entry"),
      ["<s-tab>"] = cb("select_prev_entry"),
      ["<leader>e"] = cb("focus_files"),
      ["<leader>b"] = cb("toggle_files"),
      ["q"] = cb("close"),
      ["gf"] = cb("goto_file_edit"),
    },
    file_history_panel = {
      ["gf"] = cb("goto_file_edit"),
    },
  },
})
