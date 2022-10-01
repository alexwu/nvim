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

-- TODO: Try and be smart about this -- I don't like how jarring it is
-- nvim.create_autocmd({ "WinLeave" }, {
--   pattern = "*",
--   group = "bombeelu.autocmd",
--   callback = function(o)
--     vim.wo[0].foldcolumn = "0"
--   end,
-- })
--
-- nvim.create_autocmd({ "WinEnter" }, {
--   pattern = "*",
--   group = "bombeelu.autocmd",
--   callback = function(o)
--     if vim.wo[0].foldcolumn == "0" then
--       vim.wo[0].foldcolumn = "1"
--     end
--   end,
-- })
