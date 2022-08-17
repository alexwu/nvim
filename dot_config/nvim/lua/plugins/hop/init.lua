local set = require("bombeelu.utils").set
local hop = require("hop")
local extension = require("hop-extensions")
local custom = require("plugins.hop.custom")

hop.setup({})

set("", { "S" }, function()
  custom.hint_wordmotion({ multi_windows = false })
end, { desc = "Jump to a word" })

set({ "n", "o" }, { "sw", "<Bslash>w" }, function()
  custom.hint_wordmotion({ current_line_only = true })
end, { desc = "Jump forward to a word" })

keymap({ "b" }, function()
  custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Jump backword to a word", modes = { "n", "o" } })

set({ "o" }, { "w" }, function()
  custom.hint_wordmotion({
    direction = require("hop.hint").HintDirection.AFTER_CURSOR,
    multi_windows = false,
    current_line_only = true,
  })
end, { desc = "Jump to a word" })

-- TODO: Constrain this to scope
set({ "n", "o" }, { "ss" }, function()
  custom.hint_wordmotion({ multi_windows = false })
end, { desc = "Jump to a line" })

set("n", "stl", function()
  extension.hint_locals()
end, { desc = "Jump to treesitter local" })

set("n", { "sd" }, function()
  custom.hint_diagnostics({ multi_windows = false })
end, { desc = "Jump to diagnostic" })

set("n", { "sr" }, function()
  custom.hint_usages({ multi_windows = false })
end, { desc = "Jump to usage of word under cursor" })

set({ "n", "o" }, "f", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, { desc = "Jump forward on current line" })

set({ "n", "o" }, "F", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Jump backward on current line" })

keymap("t", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.AFTER_CURSOR,
    current_line_only = true,
    hint_offset = -1,
  })
end, { desc = "Jump to the selected character" })

keymap("T", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    hint_offset = 1,
  })
end, { desc = "Jump back to the selected character" })

keymap("<BSlash>", function()
  hop.hint_char1({})
end)
