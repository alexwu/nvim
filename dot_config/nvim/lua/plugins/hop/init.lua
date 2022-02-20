local set = vim.keymap.set
local hop = require("hop")
local extension = require("hop-extensions")

hop.setup({})

set("n", "gw", function()
  require("plugins.hop.custom").hint_both_ends()
end)

set("n", "gs", function()
	hop.hint_words()
end)

set("n", "gl", function()
  hop.hint_lines_skip_whitespace()
end)

set("n", "f", function()
	hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, {})

set("n", "F", function()
	hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, {})

set("n", "go", function()
	extension.hint_textobjects()
end)
