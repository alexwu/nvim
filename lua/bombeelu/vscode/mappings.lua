local vscode = require("vscode")
-- local call = require("vscode").call
-- local notify_range = require("vscode").notify_range
-- local call_range = require("vscode").call_range
-- local notify_range_pos = require("vscode").notify_range_pos
-- local call_range_pos = require("vscode").call_range_pos

-- key.map("<C-_>", "<Plug>VSCodeCommentaryCommentaryLine", { modes = "n" })
-- key.map("<C-_>", "<Plug>VSCodeCommentary", { modes = { "x", "o" } })
set("n", "<Leader>f", [[<Cmd>call VSCodeNotifyVisual("workbench.action.quickOpen", 1)<CR>]])
-- key.map("<leader>y", [[<Cmd>call VSCodeNotify("editor.action.formatDocument") <CR>]])

set({ "n" }, { "<F8>", "<leader>y" }, function()
  vscode.action("editor.action.formatDocument")
end)

-- key.map("<C-d>", "25j", { modes = { "n", "x" } })
-- key.map("<C-u>", "25k", { modes = { "n", "x" } })

vim.cmd(
  [[nnoremap <C-u> <Cmd>call VSCodeNotify('cursorMove', { 'to': 'up', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]]
)
vim.cmd(
  [[nnoremap <C-d> <Cmd>call VSCodeNotify('cursorMove', { 'to': 'down', 'by': 'wrappedLine', 'value': v:count ? v:count : 1 })<CR>]]
)
