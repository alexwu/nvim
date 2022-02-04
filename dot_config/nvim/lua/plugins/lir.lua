local actions = require "lir.actions"
local clipboard_actions = require "lir.clipboard.actions"
local set = vim.keymap.set

require("lir").setup {
  show_hidden_files = true,
  devicons_enable = true,
  mappings = {
    ["<CR>"] = actions.edit,
    ["<C-s>"] = actions.split,
    ["<C-v>"] = actions.vsplit,
    ["<C-t>"] = actions.tabedit,

    ["h"] = actions.up,
    ["q"] = actions.quit,

    ["A"] = actions.mkdir,
    ["a"] = actions.newfile,
    ["r"] = actions.rename,
    ["@"] = actions.cd,
    ["y"] = actions.yank_path,
    ["."] = actions.toggle_show_hidden,
    ["d"] = actions.delete,

    ["c"] = clipboard_actions.copy,
    ["x"] = clipboard_actions.cut,
    ["p"] = clipboard_actions.paste,
  },
  float = {
    curdir_window = {
      enable = false,
      highlight_dirname = false,
    },
    win_opts = function()
      local width = math.floor(vim.o.columns * 0.8)
      local height = math.floor(vim.o.lines * 0.8)
      return {
        border = require("lir.float.helper").make_border_opts({
          "╭",
          "─",
          "╮",
          "│",
          "╯",
          "─",
          "╰",
          "│",
        }, "FloatBorder"),
        width = width,
        height = height,
        row = 1,
        col = math.floor((vim.o.columns - width) / 2),
      }
    end,
  },
  hide_cursor = true,
}
set("n", "-", function()
  require("lir.float").toggle()
end)
