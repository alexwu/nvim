return {
  {
    "mrjones2014/legendary.nvim",
    lazy = false,
    dependencies = { "kkharji/sqlite.lua" },
    config = function()
      require("bombeelu.legendary").setup()
      require("bombeelu.scratch").setup()
    end,
  },
}
