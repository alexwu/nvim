return {
  "mrjones2014/legendary.nvim",
  dependencies = { "kkharji/sqlite.lua" },
  config = function()
    require("bombeelu.legendary").setup()
  end,
  lazy = false,
}
