local set = require("bombeelu.utils").set
local hop = require("hop")
local ts = require("plugins.hop.ts")
local custom = require("plugins.hop.custom")

hop.setup({})

set({ "n", "x", "o" }, { "s", "<Bslash>" }, function()
  hop.hint_char2({ multi_windows = false })
end, { desc = "Jump to a word" })

set({ "n", "o" }, { "Sw", "<Bslash>w" }, function()
  custom.hint_wordmotion({ current_line_only = false })
end, { desc = "Jump forward to a word" })

set({ "n" }, { "Sj" }, function()
  hop.hint_vertical({ current_line_only = false })
end, { desc = "Jump forward to a word" })

key.map({ "Sb" }, function()
  custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Jump backword to a word", modes = { "n", "o" } })

set("n", {"<Bslash>l", "Sl"}, function()
  ts.hint_locals()
end, { desc = "Jump to treesitter local" })

set("n", { "<Bslash>d", "Sd" }, function()
  custom.hint_diagnostics({ multi_windows = false })
end, { desc = "Jump to diagnostic" })

set("n", { "<Bslash>r", "Sr" }, function()
  custom.hint_usages({ multi_windows = false })
end, { desc = "Jump to usage of word under cursor" })

set({ "n", "o" }, "Sf", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, { desc = "Jump forward on current line" })

set({ "n", "o" }, "SF", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Jump backward on current line" })

key.map("St", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.AFTER_CURSOR,
    current_line_only = true,
    hint_offset = -1,
  })
end, { desc = "Jump to the selected character" })

key.map("ST", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    hint_offset = 1,
  })
end, { desc = "Jump back to the selected character" })
