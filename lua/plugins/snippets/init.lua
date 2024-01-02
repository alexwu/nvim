return {
  "L3MON4D3/LuaSnip",
  build = (not jit.os:find("Windows"))
      and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
    or nil,
  dependencies = {
    "rafamadriz/friendly-snippets",
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  config = function()
    local ls = require("luasnip")
    ls.setup({
      history = true,
      delete_check_events = "TextChanged",
    })

    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/bombeelu/snippets" })
  end,
  keys = {},
}
