local npairs = require "nvim-autopairs"
npairs.setup {
  map_bs = false,
  check_ts = true,
  ignored_next_char = "[%w%.]",
  map_c_w = false,
  fast_wrap = {},
}

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
local cmp = require "cmp"
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
