require("globals")
require("bombeelu.nvim")
require("bombeelu.autocmd")
require("bombeelu.commands")
require("options")
require("mappings")

if vim.g.vscode then
  require("bombeelu.vscode.mappings")
else
  require("impatient")
end

if vim.g.neovide then
  require("neovide")
end

require("plugins")

if vim.g.neovide or vim.fn.has("gui_vimr") == 1 or vim.g.vscode then
  require("snazzy").setup({ theme = "dark", transparent = false })
else
  require("snazzy").setup({ theme = "dark", transparent = vim.env.TERM ~= "xterm-kitty" })
end
