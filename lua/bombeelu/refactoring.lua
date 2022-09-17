local Palette = require("bombeelu.mini-palette")
local rename = require("bombeelu.refactoring.rename")

local M = {}

function M.setup()
  set("n", { "<Leader>r", "<Leader>rr" }, M.open_refactor_list)
end

function M.open_refactor_list()
  local commands = {
    {
      display = function()
        return string.format("Rename %s", vim.fn.expand("<cword>"))
      end,
      callback = function()
        require("inc_rename").rename({ default = vim.fn.expand("<cword>") })
        -- rename.ts_rename()
      end,
      repeatable = true,
    },
  }

  Palette(commands, {
    prompt = "Select a command:",
  }):run()
end

return M
