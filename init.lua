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

-- local function pipe_path()
--   local current_root = vim.fs.root(0, "project.godot")
--   if current_root then
--     return vim.fn.stdpath("cache") .. "/server/godot.pipe"
--   end
--
--   current_root = vim.fs.root(0, ".git")
--   if current_root then
--     local normalized_name = table.concat(vim.split(current_root, [[/]]), "_")
--     -- return vim.fn.stdpath("cache") .. "/server/" .. normalized_name .. ".pipe"
--     return "./tmp/nvim.sock"
--   end
--
--   return vim.fn.stdpath("cache") .. "/server/server.pipe"
-- end
--
-- local pipepath = pipe_path()
-- if not vim.loop.fs_stat(pipepath) then
--   vim.fn.serverstart(pipepath)
-- end

-- NOTE: Get rid of the deprecation warnings for now
---@diagnostic disable-next-line: duplicate-set-field
vim.tbl_flatten = function(t)
  return vim.iter(t):flatten():totable()
end

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
