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
    opts = {},
    config = function(_, opts)
      require("xcodebuild").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = { "XcodebuildBuildFinished", "XcodebuildTestsFinished" },
        callback = function(event)
          if event.data.cancelled then
            return
          end

          if event.data.success then
            require("trouble").close()
          elseif not event.data.failedCount or event.data.failedCount > 0 then
            if next(vim.fn.getqflist()) then
              require("trouble").open("quickfix")
            else
              require("trouble").close()
            end

            require("trouble").refresh()
          end
        end,
      })
    end,
  },
}
