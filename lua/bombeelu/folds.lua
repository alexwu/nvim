local ufo = require("ufo")
local keys = require("bombeelu.keys")
local rpt = require("bombeelu.repeat").mk_repeatable

local M = {}

function M.setup()
  vim.o.foldcolumn = "1"
  vim.o.foldlevel = 99
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  set("n", "zR", ufo.openAllFolds, { desc = "Open all folds" })
  set("n", "zM", ufo.closeAllFolds, { desc = "Close all folds" })

  set(
    "n",
    "zc",
    rpt(function()
      keys.feed({ "z", "c" })
    end),
    { desc = "Close fold under cursor" }
  )

  set(
    "n",
    "zo",
    rpt(function()
      keys.feed({ "z", "o" })
    end),
    { desc = "Open fold under cursor" }
  )

  set(
    "n",
    "zz",
    rpt(function()
      keys.feed({
        "z",
        "a",
      })
    end),
    { desc = "Toggle fold under cursor" }
  )

  set(
    "n",
    "zA",
    rpt(function()
      keys.feed({ "z", "A" })
    end),
    { desc = "Toggle fold under cursor recursively" }
  )

  ufo.setup()
end

return M
