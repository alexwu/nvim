local set = require("bombeelu.utils").set
local hop = require("hop")
local ts = require("plugins.hop.ts")
local custom = require("plugins.hop.custom")

hop.setup()
--
-- set({ "n" }, { "<Tab>" }, function()
--   hop.hint_char2({ current_line_only = false })
-- end, { desc = "Hop to characters" })

set({ "n" }, { "sw" }, function()
  custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, { desc = "Hop forward to a word" })

set("n", { "sd" }, function()
  custom.hint_diagnostics({ multi_windows = false })
end, { desc = "Hop to diagnostic" })

set({ "n" }, { "sj" }, function()
  hop.hint_vertical({ current_line_only = false })
end, { desc = "Hop vertically" })

key.map({ "sb" }, function()
  custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Hop backword to a word", modes = { "n", "o" } })

set("n", { "sl" }, function()
  ts.hint_locals()
end, { desc = "Hop to treesitter local" })

set("n", { "<Bslash>r", "sr" }, function()
  custom.hint_usages({ multi_windows = false })
end, { desc = "Hop to usage of word under cursor" })

set({ "n" }, "sf", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
end, { desc = "Hop forward on current line" })

set({ "n" }, "sF", function()
  hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
end, { desc = "Hop backward on current line" })
