local set = require("bombeelu.utils").set
local hop = require("hop")
local ts = require("plugins.hop.ts")
local custom = require("plugins.hop.custom")

hop.setup({})

set("n", { "s" }, function()
  custom.hint_wordmotion({ multi_windows = false })
end, { desc = "Jump to a word" })

set("o", { "<Bslash>" }, function()
  hop.hint_char1({ multi_windows = false })
end, { desc = "Jump to a word" })

set({ "n", "o" }, { "sw", "<Bslash>w" }, function()
  custom.hint_wordmotion({ current_line_only = true })
end, { desc = "Jump forward to a word" })

keymap({ "sb" }, function()
  custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Jump backword to a word", modes = { "n", "o" } })

set({ "n", "o" }, { "S" }, function()
  hop.hint_char2({ multi_windows = false })
end, { desc = "Jump to a line" })

set("n", "sl", function()
  ts.hint_locals()
end, { desc = "Jump to treesitter local" })

set("n", { "sd" }, function()
  custom.hint_diagnostics({ multi_windows = false })
end, { desc = "Jump to diagnostic" })

set("n", { "sr" }, function()
  custom.hint_usages({ multi_windows = false })
end, { desc = "Jump to usage of word under cursor" })

set({ "n", "o" }, "sf", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, { desc = "Jump forward on current line" })

set({ "n", "o" }, "sF", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Jump backward on current line" })

key.map("st", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.AFTER_CURSOR,
    current_line_only = true,
    hint_offset = -1,
  })
end, { desc = "Jump to the selected character" })

key.map("sT", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    hint_offset = 1,
  })
end, { desc = "Jump back to the selected character" })

keymap("<BSlash><BSlash>", function()
  hop.hint_char1({})
end)
