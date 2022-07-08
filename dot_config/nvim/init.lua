require("globals")

if vim.fn.has("gui_vimr") == 1 or vim.fn.exists("g:vscode") == 1 then
  require("snazzy").setup({ theme = "dark", transparent = false })
else
  require("impatient")
  require("plugins")

  -- local transparent = vim.env.TERM_PROGRAM == "WezTerm" or vim.env.TERM_PROGRAM == "iTerm.app"
  local transparent = vim.env.TERM ~= "xterm-kitty"
  require("snazzy").setup({ theme = "dark", transparent = transparent })

  require("plugins.treesitter")
end

if vim.g.neovide then
  require("neovide")
end

require("options")
require("mappings")
require("bombeelu.commands")
require("bombeelu.autocommands")

require("bombeelu.projects.ruby")

require("bombeelu.rename").setup()
vim.keymap.set("n", "<leader>rn", function()
  require("bombeelu.rename").rename({ default = vim.fn.expand("<cword>") })
end, { expr = true })
