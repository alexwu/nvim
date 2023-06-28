local M = {}

function M.setup()
  require("legendary").setup({
    include_legendary_cmds = false,
    select_prompt = "Command Palette",
    keymaps = {
      { "<C-S-p>", vim.cmd.Legendary, description = "Find keymaps and commands", mode = { "n", "x", "i", "t" } },
    },
    extensions = {
      smart_splits = true,
      diffview = true,
    },
    lazy_nvim = { auto_register = true },
  })
end

return M
