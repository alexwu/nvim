local leap = require("leap")

local M = {}

function M.setup()
  leap.setup({
    max_aot_targets = 0,
  })

  set("n", "<BSlash>", "<Plug>(leap-forward)", { desc = "Leap to a character" })

  -- { "n", "S", "<Plug>(leap-backward)" },
  -- { "x", "s", "<Plug>(leap-forward)" },
  -- { "x", "S", "<Plug>(leap-backward)" },
  -- { "o", "z", "<Plug>(leap-forward)" },
  -- { "o", "Z", "<Plug>(leap-backward)" },
  -- { "o", "x", "<Plug>(leap-forward-x)" },
  -- { "o", "X", "<Plug>(leap-backward-x)" },
  -- { "n", "gs", "<Plug>(leap-cross-window)" },
  -- { "x", "gs", "<Plug>(leap-cross-window)" },
  -- { "o", "gs", "<Plug>(leap-cross-window)" },
end

return M
