return {
  "phaazon/hop.nvim",
  dependencies = { "nvim-telescope/telescope.nvim", "nvim-treesitter/nvim-treesitter", "kylechui/nvim-surround" },
  config = function()
    local set = require("bombeelu.utils").set
    local hop = require("hop")
    local ts = require("plugins.hop.ts")
    local custom = require("plugins.hop.custom")

    hop.setup()
    --
    set({ "n" }, { "<Tab>" }, function()
      hop.hint_char2({ current_line_only = false })
    end, { desc = "Hop to characters" })

    -- set({ "n" }, { "s" }, function()
    --   hop.hint_char2({ current_line_only = false, direction = require("hop.hint").HintDirection.AFTER_CURSOR })
    -- end, { desc = "Hop to characters ahead of cursor" })
    --
    -- set({ "n" }, { "S" }, function()
    --   hop.hint_char2({ current_line_only = false, direction = require("hop.hint").HintDirection.BEFORE_CURSOR })
    -- end, { desc = "Hop to characters before cursor" })

    set({ "n" }, { "gsw" }, function()
      custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
    end, { desc = "Hop forward to a word" })

    set("n", { "gsd" }, function()
      custom.hint_diagnostics({ multi_windows = false })
    end, { desc = "Hop to diagnostic" })

    set({ "n" }, { "gsj" }, function()
      hop.hint_vertical({ current_line_only = false })
    end, { desc = "Hop vertically" })

    -- key.map({ "gsb" }, function()
    --   custom.hint_wordmotion({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
    -- end, { desc = "Hop backword to a word", modes = { "n", "o" } })

    set("n", { "gsl" }, function()
      ts.hint_locals()
    end, { desc = "Hop to treesitter local" })

    set("n", { "gsr" }, function()
      custom.hint_usages({ multi_windows = false })
    end, { desc = "Hop to usage of word under cursor" })

    -- set({ "n" }, "sf", function()
    --   hop.hint_char1({ direction = require("hop.hint").HintDirection.AFTER_CURSOR, current_line_only = true })
    -- end, { desc = "Hop forward on current line" })
    --
    -- set({ "n" }, "sF", function()
    --   hop.hint_char1({ direction = require("hop.hint").HintDirection.BEFORE_CURSOR, current_line_only = true })
    -- end, { desc = "Hop backward on current line" })
  end,
}
