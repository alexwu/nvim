local set = vim.keymap.set
local Terminal = require("toggleterm.terminal").Terminal

-- local lazygit = Terminal:new({
--   cmd = "lazygit",
--   direction = "float",
--   hidden = false,
-- })
--
-- vim.api.nvim_create_user_command("LazyGit", function()
--   lazygit:toggle()
-- end, { nargs = 0 })
--
-- vim.api.nvim_create_user_command("LG", function()
--   lazygit:toggle()
-- end, { nargs = 0 })

local function enter_terminal_normal_mode()
  nvim.feedkeys(nvim.replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
end

require("toggleterm").setup({
  size = function(term)
    if term.direction == "horizontal" then
      return 20
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.8
    end
  end,
  open_mapping = [[<C-\>]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 1,
  start_in_insert = true, -- NOTE: When this it true it makes you kill the buffer if the process exited
  insert_mappings = true,
  terminal_mappings = true,
  persist_size = true,
  direction = "float",
  -- direction = "horizontal",
  close_on_exit = false,
  float_opts = {
    border = "rounded",
    width = vim.fn.round(0.9 * vim.o.columns),
    height = vim.fn.round(0.9 * vim.o.lines),
    winblend = 10,
    highlights = { border = "FloatBorder", background = "Normal" },
  },
  on_open = function()
    -- enter_terminal_normal_mode()
    set("t", "<Esc>", "<C-BSlash><C-n>", { buffer = true })
  end,
  winbar = {
    enabled = true,
  },
})

vim.cmd([[
  if has('nvim')
    let $GIT_EDITOR = "nvim --server $NVIM --remote"
  endif
]])
