local utils = require("bombeelu.utils")
local lazy = utils.lazy
local set = utils.set
local ex = utils.ex

nvim.create_augroup("bombeelu.autocmd", { clear = true })
nvim.create_autocmd("FileType", {
  pattern = "qf",
  group = "bombeelu.autocmd",
  callback = function()
    set("n", "<CR>", "<CR>" .. ex("cclose"), { buffer = true })
    set("n", "<ESC>", lazy(vim.cmd.cclose), { buffer = true })
  end,
})

nvim.create_autocmd("FileType", {
  pattern = "help",
  group = "bombeelu.autocmd",
  callback = function()
    set("n", "gd", "<C-]>", { buffer = true })
  end,
})

nvim.create_autocmd("DirChanged", {
  pattern = "help",
  group = "bombeelu.autocmd",
  callback = function()
    set("n", "gd", "<C-]>", { buffer = true })
  end,
})

nvim.create_autocmd({ "BufEnter" }, {
  pattern = "*",
  group = "bombeelu.autocmd",
  callback = function()
    vim.opt.formatoptions:remove({ "c", "o", "r" })
  end,
})

-- Credit: https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/config/autocmds.lua#L52
nvim.create_autocmd("FileType", {
  group = "bombeelu.autocmd",
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "neotest-output",
    "checkhealth",
    "neotest-summary",
    "neotest-output-panel",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
