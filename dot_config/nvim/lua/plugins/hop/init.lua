local set = vim.keymap.set
local hop = require("hop")
local extension = require("hop-extensions")
local custom = require("plugins.hop.custom")

hop.setup({})

set({ "n", "o" }, "s", function()
	hop.hint_words({ multi_windows = false })
end)

set("n", "go", function()
	extension.hint_locals()
end)

set("n", "gl", function()
	hop.hint_lines_skip_whitespace()
end)

set("n", "gsd", function()
	custom.hint_diagnostics({ multi_windows = true })
end, { desc = "Hop to LSP diagnostic" })

set("n", "go", function()
	extension.hint_textobjects()
end)

set({ "n", "o" }, "f", function()
	hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, {})

set({ "n", "o" }, "F", function()
	hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, {})
