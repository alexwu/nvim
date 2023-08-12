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

if vim.g.vscode then
  require("lazy").setup("vscode", {
    dev = {
      path = "~/Code/neovim/plugins",
      patterns = { "alexwu" },
      fallback = true,
    },
  })
else
  -- If opening from inside neovim terminal then do not load all the other plugins
  if os.getenv("NVIM") ~= nil then
    require("lazy").setup({
      { "willothy/flatten.nvim", config = true },
    })
    return
  else
    require("lazy").setup("plugins", {
      dev = {
        path = "~/Code/neovim/plugins",
        patterns = { "alexwu" },
        fallback = true,
      },
    })
  end
end

if vim.g.neovide then
  require("neovide")
end
