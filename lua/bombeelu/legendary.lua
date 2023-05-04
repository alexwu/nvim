local M = {}

function M.setup()
  require("legendary").setup({
    include_legendary_cmds = false,
    keymaps = {
      { "<C-S-p>", vim.cmd.Legendary, description = "Find keymaps and commands", mode = { "n", "x", "i", "t" } },
    },
    extensions = {
      smart_splits = true,
      diffview = true,
    },
  })
end

return M
