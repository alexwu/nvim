local set = vim.keymap.set

require("fzf-lua").setup {
  win_border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  fzf_args = "--color 'fg:#f9f9ff,fg+:#f3f99d,hl:#5af78e,hl+:#5af78e,spinner:#5af78e,pointer:#ff6ac1,info:#5af78e,prompt:#9aedfe,gutter:#282a36'",
  fzf_layout = "default",
  -- preview_cmd = "",
  -- preview_border = "border",
  -- preview_wrap = "nowrap",
  -- preview_opts = "nohidden",
  -- preview_vertical = "down:45%",
  -- preview_horizontal = "right:60%",
  preview_layout = "flex",
  flip_columns = 120,
  bat_theme = "Sublime Snazzy",
  files = {
    prompt = "❯ ",
    cmd = "",
    git_icons = false,
    file_icons = true,
    color_icons = true,
  },
  grep = {
    prompt = "Grep ❯ ",
    input_prompt = "Grep For❯ ",
    git_icons = true,
    file_icons = true,
    color_icons = true,
  },
  file_icon_colors = {
    ["lua"] = "blue",
    ["rb"] = "red",
    ["gemfile"] = "red",
    ["js"] = "yellow",
    ["jsx"] = "cyan",
    ["ts"] = "blue",
    ["tsx"] = "cyan",
  },
  keymap = {
    fzf = {
      ["ctrl-u"] = "unix-line-discard",
    },
  },
  on_create = function()
    vim.api.nvim_buf_set_keymap(0, "t", "<Esc>", "<C-c>", { nowait = true, silent = true })
  end,
  lsp = { async_or_timeout = 3000 },
}

-- set("n", "<Leader>f", function()
--   require("fzf-lua").files()
-- end)
-- set("n", "<Leader>rg", function()
--   require("fzf-lua").live_grep()
-- end)
-- set("n", "<Leader>ag", function()
--   require("fzf-lua").live_grep()
-- end)
--
-- vim.api.nvim_add_user_command("Rg", function() end, { nargs = 0 })
