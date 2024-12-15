local M = {}

function M.setup()
  local easypick = require("easypick")
  easypick.setup({
    pickers = {
      {
        name = "conflicts",
        command = "git diff --name-only --diff-filter=U --relative",
        previewer = easypick.previewers.file_diff(),
      },
    },
  })
end

return M
