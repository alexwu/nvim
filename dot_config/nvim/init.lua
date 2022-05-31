require("globals")

-- vim.opt.rtp:append(vim.fn.expand("~/.luarocks/lib/luarocks/rocks-5.1"))

local ok, tealmaker = pcall(require, "tealmaker")
if ok and vim.fn.executable("tl") == 1 then
  tealmaker.build_all()
end

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
