return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    cond = function()
      local result = require("bombeelu.utils").root_pattern(
        "buildServer.json",
        "*.xcodeproj",
        "*.xcworkspace",
        "compile_commands.json",
        "Package.swift"
      )(vim.uv.cwd())

      return result
    end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
    opts = {},
  },
}
