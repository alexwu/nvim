local notify = require("vscode-neovim").notify
local call = require("vscode-neovim").call
local notify_range = require("vscode-neovim").notify_range
local call_range = require("vscode-neovim").call_range
local notify_range_pos = require("vscode-neovim").notify_range_pos
local call_range_pos = require("vscode-neovim").call_range_pos

key.map("<C-_>", "<Plug>VSCodeCommentaryCommentaryLine", { modes = "n" })
key.map("<C-_>", "<Plug>VSCodeCommentary", { modes = { "x", "o" } })
key.map("<Leader>f", [[<Cmd>call VSCodeNotifyVisual("workbench.action.quickOpen", 1)<CR>]], { modes = "n" })
-- key.map("<leader>y", [[<Cmd>call VSCodeNotify("editor.action.formatDocument") <CR>]])

key.map({ "<F8>", "<leader>y" }, function()
  notify("editor.action.formatDocument")
end)

-- key.map("<C-d>", "25j", { modes = { "n", "x" } })
-- key.map("<C-u>", "25k", { modes = { "n", "x" } })

vim.cmd(
  [[nnoremap <C-u> <Cmd>call VSCodeNotify('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]]
)
vim.cmd(
  [[nnoremap <C-d> <Cmd>call VSCodeNotify('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]]
)
