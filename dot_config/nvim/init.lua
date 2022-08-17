require("globals")
require("bombeelu.nvim")

if vim.g.vscode then
--  require("vscode")
else
  --  require("impatient")
  require("plugins")
  require("plugins.treesitter")
end

if vim.fn.has("gui_vimr") == 1 or vim.fn.exists("g:vscode") == 1 then
  require("snazzy").setup({ theme = "dark", transparent = false })
else
  require("snazzy").setup({ theme = "dark", transparent = vim.env.TERM ~= "xterm-kitty" })
end

if vim.g.neovide then
  require("neovide")
end

require("options")
require("mappings")
