key.map("<C-_>", "<Plug>VSCodeCommentaryCommentaryLine", { modes = "n" })
key.map("<C-_>", "<Plug>VSCodeCommentary", { modes = { "x", "o" } })
key.map("<Leader>f", [[<Cmd>call VSCodeNotifyVisual("workbench.action.quickOpen", 1)<CR>]], { modes = "n" })
key.map("<leader>y", [[<Cmd>call VSCodeNotify("editor.action.formatDocument") <CR>]])

key.map("<C-d", "25j", { modes = { "n", "x" } })
key.map("<C-u", "25j", { modes = { "n", "x" } })
