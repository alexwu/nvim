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
    set("n", "<ESC>", lazy(nvim.ex.cclose), { buffer = true })
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
    vim.opt.formatoptions:remove("c"):remove("o"):remove("r")
  end,
})
