local set = vim.keymap.set
local hop = require("hop")
local extension = require("hop-extensions")

hop.setup({})

set("n", "<Leader>w", function()
	require("plugins.hop.custom").hint_both_ends()
end)

-- set({"n", "o"}, "s", function()
--   require("plugins.hop.custom").hint_both_ends()
-- end)

set("n", "gs", function()
	require("plugins.hop.custom").hint_both_ends()
end)

set("n", "f", function()
	require("hop").hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, {})

set("n", "F", function()
	require("hop").hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, {})

-- set("n", "<Leader>l", function()
--   extension.hint_textobjects()
-- end)

-- set("n", "<Leader>d", function()
--   extension.hint_diagnostics()
-- end)
