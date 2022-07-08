local utils = require("bombeelu.utils")
local set = utils.set
local ex = utils.ex

nvim.create_augroup("bombeelu.autocmd", { clear = true })
nvim.create_autocmd("FileType", {
  pattern = "qf",
  group = "bombeelu.autocmd",
  callback = function()
    set("n", "<CR>", "<CR>" .. ex("cclose"), { buffer = true })
  end,
})

vim.cmd([[autocmd FileType qf nnoremap <buffer> <silent> <ESC> :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> q :cclose<CR>]])
vim.cmd([[autocmd FileType help nnoremap <buffer> <silent> gd <C-]>]])
