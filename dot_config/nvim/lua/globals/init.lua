-- Disable unneded builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

_G.keymap = require("bombeelu.utils").keymap
_G.key = {
  map = require("bombeelu.utils").keymap,
}
_G.set = require("bombeelu.utils").set
