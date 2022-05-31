local set = require("bombeelu.utils").set
local hop = require("hop")
local extension = require("hop-extensions")
local custom = require("plugins.hop.custom")

hop.setup({})

set({ "n", "o" }, { "s", "S" }, function()
	hop.hint_words({ multi_windows = false })
end, { desc = "Jump to a word" })

set("n", "go", function()
	extension.hint_locals()
end, { desc = "Jump to treesitter local" })

set("n", "gl", function()
	hop.hint_lines_skip_whitespace()
end, { desc = "Jump to line" })

set("n", "SD", function()
	custom.hint_diagnostics({ multi_windows = true })
end, { desc = "Jump to diagnostic" })

set("n", "go", function()
	extension.hint_textobjects()
end, { desc = "Jump to text object" })

set({ "n", "o" }, "f", function()
	hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, { desc = "Jump forward on current line" })

set({ "n", "o" }, "F", function()
	hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Jump backward on current line" })
