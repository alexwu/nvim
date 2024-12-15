return {
  {
    "ray-x/go.nvim",
    dependencies = { "ray-x/guihua.lua" },
    ft = {"go"},
    config = function()
      require("bombeelu.lsp.go").setup()
    end,
    cond = function()
      return not vim.g.vscode
    end,
  },
}
