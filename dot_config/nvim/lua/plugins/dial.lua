local dial = require "dial"
local set = vim.keymap.set

dial.augends["custom#boolean"] = dial.common.enum_cyclic {
  name = "boolean",
  strlist = { "true", "false" },
}
dial.augends["custom#tests"] = dial.common.enum_cyclic {
  name = "tests",
  strlist = { "it", "fit", "xit" },
}
dial.augends["custom#enable"] = dial.common.enum_cyclic {
  name = "enable",
  strlist = { "enable", "disable" },
}
table.insert(dial.config.searchlist.normal, "custom#boolean")
table.insert(dial.config.searchlist.normal, "custom#tests")
table.insert(dial.config.searchlist.normal, "custom#enable")

dial.config.searchlist.visual = {
  "number#decimal",
  "number#hex",
  "number#binary",
  "date#[%Y/%m/%d]",
}

set({ "n", "v" }, "<C-a>", "<Plug>(dial-increment)")
set({ "n", "v" }, "<C-x>", "<Plug>(dial-decrement)")
