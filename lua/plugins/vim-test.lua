local set = vim.keymap.set

local function enter_terminal_normal_mode()
  nvim.feedkeys(nvim.replace_termcodes([[<C-\><C-n>]], true, false, true), "n", false)
end

_G.toggleterm_strategy = function(cmd)
  require("toggleterm.terminal").Terminal
    :new({
      cmd = cmd,
      close_on_exit = false,
      hidden = false,
      direction = "float",
      float_opts = {
        border = "rounded",
        width = vim.fn.round(0.9 * vim.o.columns),
        height = vim.fn.round(0.9 * vim.o.lines),
        winblend = 15,
        highlights = { border = "FloatBorder", background = "Normal" },
      },
      on_open = function(term)
        enter_terminal_normal_mode()
        vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
      end,
    })
    :toggle()
end

vim.cmd([[
function! ToggletermStrategy(cmd)
  let g:cmd = a:cmd . "\n"
  lua toggleterm_strategy(vim.g.cmd)
endfunction

let g:test#custom_strategies = {'toggleterm': function('ToggletermStrategy')}
]])

vim.cmd([[
function! FTermStrategy(cmd)
  let g:cmd = a:cmd . "\n"
  lua require("plugins.vim-test").fterm_strategy(vim.g.cmd)
endfunction

let g:test#custom_strategies = {'fterm': function('FTermStrategy')}
]])

vim.api.nvim_set_var("test#strategy", "fterm")
-- vim.api.nvim_set_var("test#strategy", "kitty")
-- vim.api.nvim_set_var("test#strategy", "toggleterm")
vim.api.nvim_set_var("test#ruby#rspec#executable", "bundle exec rspec")
vim.api.nvim_set_var("test#ruby#rspec#patterns", "_spec.rb")
vim.api.nvim_set_var("test#ruby#rspec#options", {
  file = "--format documentation --force-color",
  suite = "--format documentation --force-color",
  nearest = "--format documentation --force-color",
})
vim.api.nvim_set_var("test#javascript#jest#options", "--color=always")
vim.api.nvim_set_var("test#typescript#jest#options", "--color=always")
-- vim.api.nvim_set_var("test#rust#cargo#options",  'verbose')
vim.env.DEBUG_PRINT_LIMIT = 20000
vim.env.RUST_LOG = "trace"
set("n", "<F7>", "<cmd>TestNearest<CR>")
set("n", "<F9>", "<cmd>TestFile<CR>")

local M = {}

M.terminal = require("FTerm.terminal"):new({
  border = "rounded",
})

M.fterm_strategy = function(cmd)
  require("FTerm").scratch({
    border = "rounded",
    cmd = cmd,
  })
end

set({ "n", "t" }, [[<A-Bslash>]], function()
  M.terminal:toggle()
end)

return M
