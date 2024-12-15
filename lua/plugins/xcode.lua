return {
  {
    "wojciech-kulik/xcodebuild.nvim",
    lazy = true,
    init = function()
      local loaded = false
      local function check()
        local result = require("bombeelu.utils").root_pattern(
          "buildServer.json",
          "*.xcodeproj",
          "*.xcworkspace",
          "compile_commands.json",
          "Package.swift"
        )(vim.uv.cwd() or vim.uv.os_homedir())

        if result then
          require("lazy").load({ plugins = { "xcodebuild.nvim" } })
          loaded = true
        end
      end
      check()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = require("bu").nvim.augroup("xcode.custom"),
        callback = function()
          if not loaded then
            check()
          end
        end,
      })
    end,
    -- cond = function()
    --   local result = require("bombeelu.utils").root_pattern(
    --     "buildServer.json",
    --     "*.xcodeproj",
    --     "*.xcworkspace",
    --     "compile_commands.json",
    --     "Package.swift"
    --   )(vim.uv.cwd() or vim.uv.os_homedir())
    --
    --   return result
    -- end,
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    config = true,
    opts = {},
  },
}
