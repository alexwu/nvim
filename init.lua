local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--single-branch",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

vim.g.mapleader = " "
require("options")

require("lazy").setup("plugins", {
  dev = {
    path = "~/Code/neovim/plugins",
    patterns = { "alexwu" },
    fallback = true,
  },
})

if vim.g.vscode then
  require("bombeelu.vscode.mappings")
elseif vim.g.neovide then
  require("neovide")
end

require("plugins")
