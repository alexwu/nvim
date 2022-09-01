require("globals")
require("bombeelu.nvim")
require("bombeelu.autocmd")
require("bombeelu.commands")
require("options")
require("mappings")

if vim.g.vscode then
  require("bombeelu.vscode.mappings")
elseif vim.g.neovide then
  require("neovide")
else
  require("impatient")
end

require("plugins")

if vim.g.neovide or vim.fn.has("gui_vimr") == 1 or vim.g.vscode or vim.g.goneovim then
  require("snazzy").setup({ theme = "dark", transparent = false })
else
  require("snazzy").setup({ theme = "dark", transparent = vim.env.TERM ~= "xterm-kitty" })
end

require("bombeelu.pin").setup()
require("bombeelu.visual-surround").setup()
