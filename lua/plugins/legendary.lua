return {
  "mrjones2014/legendary.nvim",
  dependencies = { "kkharji/sqlite.lua" },
  config = function()
    require("bombeelu.legendary").setup()
  end,
  cond = function()
    return not vim.g.vscode
  end,
  lazy = false,
}
