return {
  {
    "nvim-lua/plenary.nvim",
    config = function()
      require("plenary.filetype").add_file("extras")
      require("globals")
      require("bombeelu.nvim")
      require("bombeelu.autocmd")
      require("bombeelu.commands")
      require("mappings")

      if not vim.g.vscode then
        -- require("bombeelu.pin").setup()
        require("bombeelu.visual-surround").setup()
        -- require("bombeelu.refactoring").setup()
        -- require("bombeelu.just").setup()
      end
    end,
    lazy = false,
    priority = 1001,
  },
  {
    "alexwu/bombeeutils",
    -- lazy = false,
    dev = true,
    branch = "dev",
    url = "git@github.com:alexwu/bombeeutils.git"
  },
}
