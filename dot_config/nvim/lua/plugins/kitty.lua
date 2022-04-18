local set = vim.keymap.set
local if_nil = vim.F.if_nil

vim.g.kitty_navigator_no_mappings = 1

set("n", "<A-h>", "<cmd>KittyNavigateLeft<cr>")
set("n", "<A-l>", "<cmd>KittyNavigateRight<cr>")
set("n", "<A-j>", "<cmd>KittyNavigateDown<cr>")
set("n", "<A-k>", "<cmd>KittyNavigateUp<cr>")

set("n", "<C-Left>", "<cmd>KittyNavigateLeft<cr>")
set("n", "<C-Right>", "<cmd>KittyNavigateRight<cr>")
set("n", "<C-Down>", "<cmd>KittyNavigateDown<cr>")
set("n", "<C-Up>", "<cmd>KittyNavigateUp<cr>")

-- TODO: Finish this
-- local kitty_split = function(opts)
--   opts = if_nil(opts, {})
--   local fargs = if_nil(opts.fargs, {})
--
--   local filename = fargs[1]
--
--   vim.cmd[[<cmd>split ]]
-- end
--
-- vim.api.nvim_create_user_command("KSplit", kitty_split)
