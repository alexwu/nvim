local ok, plenary = pcall(require, "plenary")
if ok then
  require("globals")
  require("bombeelu.nvim")
  require("bombeelu.autocmd")
  require("bombeelu.commands")
  require("options")
  require("mappings")
end

if vim.g.vscode then
  require("bombeelu.vscode.mappings")
elseif vim.g.neovide then
  require("neovide")
else
  local ok, _ = pcall(require, "impatient")
  if ok then
    require("impatient")
  end
end

require("plugins")

if vim.g.neovide or vim.fn.has("gui_vimr") == 1 or vim.g.vscode or vim.g.goneovim then
  require("snazzy").setup({ theme = "dark", transparent = false })
else
  vim.cmd("colorscheme snazzy")
  -- require("snazzy").setup({ theme = "dark", transparent = vim.env.TERM ~= "xterm-kitty" })
end

require("bombeelu.pin").setup()
require("bombeelu.visual-surround").setup()
require("bombeelu.refactoring").setup()