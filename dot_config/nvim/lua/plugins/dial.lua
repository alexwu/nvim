local augend = require("dial.augend")
local set = vim.keymap.set

require("dial.config").augends:register_group({
  default = {
    augend.integer.alias.decimal,
    augend.integer.alias.decimal_int,
    augend.constant.alias.bool,
    augend.constant.new({
      elements = { "and", "or" },
      word = true,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "&&", "||" },
      word = false,
      cyclic = true,
    }),
    augend.constant.new({
      elements = { "it", "fit", "xit" },
      word = true,
      cyclic = true,
    }),
  },
})

set("n", "<C-a>", require("dial.map").inc_normal(), { noremap = true })
set("n", "<C-x>", require("dial.map").dec_normal(), { noremap = true })

set("v", "<C-a>", require("dial.map").inc_visual(), { noremap = true })
set("v", "<C-x>", require("dial.map").dec_visual(), { noremap = true })
