local set = require("bombeelu.utils").set
local hop = require("hop")
local ts = require("plugins.hop.ts")
local custom = require("plugins.hop.custom")

hop.setup({})

set({ "n", "x", "o" }, { "S", "ss", "<Bslash>" }, function()
  hop.hint_char1({ multi_windows = false })
end, { desc = "Hop to a specified character" })

set({ "n", "o" }, { "s", "<Bslash>w" }, function()
  custom.hint_wordmotion({ current_line_only = false })
end, { desc = "Hop forward to a word" })

set({ "n" }, { "sj" }, function()
  hop.hint_vertical({ current_line_only = false })
end, { desc = "Hop forward to a word" })

key.map({ "sb" }, function()
  custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Hop backword to a word", modes = { "n", "o" } })

set("n", { "<Bslash>l", "sl" }, function()
  ts.hint_locals()
end, { desc = "Hop to treesitter local" })

set("n", { "<Bslash>d", "sd" }, function()
  custom.hint_diagnostics({ multi_windows = false })
end, { desc = "Hop to diagnostic" })

set("n", { "<Bslash>r", "sr" }, function()
  custom.hint_usages({ multi_windows = false })
end, { desc = "Hop to usage of word under cursor" })

set({ "n", "o" }, "sf", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, { desc = "Hop forward on current line" })

set({ "n", "o" }, "sF", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Hop backward on current line" })

key.map("st", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.AFTER_CURSOR,
    current_line_only = true,
    hint_offset = -1,
  })
end, { desc = "Hop to the selected character" })

key.map("sT", function()
  hop.hint_char1({
    direction = require("hop.hint").HintDirection.BEFORE_CURSOR,
    current_line_only = true,
    hint_offset = 1,
  })
end, { desc = "Hop back to the selected character" })
