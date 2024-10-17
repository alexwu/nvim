local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
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

-- If opening from inside neovim terminal then do not load all the other plugins
if not vim.g.vscode and os.getenv("NVIM") ~= nil then
  require("lazy").setup({
    { "willothy/flatten.nvim", config = true },
  })
  return
else
  require("lazy").setup("plugins", {
    spec = {
      -- { import = "minimal" },
      { import = "plugins" },
    },
    defaults = {
      -- Set this to `true` to have all your plugins lazy-loaded by default.
      -- Only do this if you know what you are doing, as it can lead to unexpected behavior.
      lazy = false, -- should plugins be lazy-loaded?
      -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
      -- have outdated releases, which may break your Neovim install.
      version = nil, -- always use the latest git commit
      -- version = "*", -- try installing the latest stable version for plugins that support semver
      -- default `cond` you can use to globally disable a lot of plugins
      -- when running inside vscode for example
      cond = function()
        return not vim.g.vscode
      end, ---@type boolean|fun(self:LazyPlugin):boolean|nil
    },
    install = { colorscheme = { "snazzy", "dracula", "tokyonight" } },
    dev = {
      path = "~/Code/neovim/plugins",
      patterns = { "alexwu" },
      fallback = true,
    },
    ui = {
      border = "rounded",
    },
    diff = {
      cmd = "diffview.nvim",
    },
  })
end

if vim.g.neovide then
  require("neovide")
end
