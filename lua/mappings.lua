local utils = require("bombeelu.utils")
local keys = require("bombeelu.keys")
local ex = utils.ex
local lazy = utils.lazy
local repeatable = require("bombeelu.repeat").mk_repeatable

vim.g.mapleader = " "

-- set("n", "S", "<Nop>")

key.map(
  { "j", "<Down>" },
  'v:count || mode(1)[0:1] == "no" ? "j" : "gj"',
  { expr = true, modes = "n", desc = "Move down a line" }
)
key.map(
  { "k", "<Up>" },
  'v:count || mode(1)[0:1] == "no" ? "k" : "gk"',
  { expr = true, modes = "n", desc = "Move up a line" }
)

key.map({ "<" }, "<gv", { modes = "x" })
key.map({ ">", "<Tab>" }, ">gv", { modes = "x" })

-- key.map("gs", [[:%s/\<<C-R><C-W>\>\C//g<left><left>]], { modes = { "n" } })
--
set({ "n" }, "<C-j>", function()
  keys.feed({ "<C-w>", "<C-j>" })
end)

set({ "n" }, "<C-h>", function()
  keys.feed({ "<C-w>", "<C-h>" })
end)

set({ "n" }, "<C-k>", "<C-w><C-k>")
set({ "n" }, "<C-l>", "<C-w><C-l>")

key.map("<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
key.map("<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Move Lines
vim.keymap.set("n", "<A-j>", ":m .+1<cr>==", { desc = "Move down" })
vim.keymap.set("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
vim.keymap.set("i", "<A-j>", "<Esc>:m .+1<cr>==gi", { desc = "Move down" })
vim.keymap.set("n", "<A-k>", ":m .-2<cr>==", { desc = "Move up" })
vim.keymap.set("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })
vim.keymap.set("i", "<A-k>", "<Esc>:m .-2<cr>==gi", { desc = "Move up" })

set("n", "<ESC>", ex("noh"))
set("x", "<F2>", '"*y', { desc = "Copy to system clipboard" })
set("n", "<A-BS>", "db", { desc = "Delete previous word" })
set("i", "<A-BS>", "<C-W>", { desc = "Delete previous word" })

vim.keymap.set({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

vim.keymap.set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open Location List" })
vim.keymap.set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open Quickfix List" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  vim.keymap.set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end

set("n", "Q", lazy(vim.cmd.quit))

set(
  "n",
  { "<A-o>", "]<Space>" },
  repeatable(function()
    keys.feed({ "o", "<ESC>" })
  end)
)

set(
  "n",
  { "<A-O>", "[<Space>" },
  repeatable(function()
    keys.feed({ "O", "<ESC>" })
  end)
)

set(
  "n",
  "[z",
  repeatable(function()
    keys.feed({ "[", "z" })
  end, { desc = "Move to the start of the current open fold" })
)

set(
  "n",
  "]z",
  repeatable(function()
    keys.feed({ "]", "z" })
  end, { desc = "Move to the end of the current open fold" })
)

local function scroll_half_page(dir, opts)
  opts = vim.F.if_nil(opts, {})
  local bufnr = vim.F.if_nil(opts.bufnr, nvim.get_current_buf())
  local line_count = nvim.buf_line_count(bufnr)
  local height = nvim.win_get_height(0)
  local half_height = math.floor(height / 2)
  local row, col = unpack(nvim.win_get_cursor(0))

  if dir == "down" then
    local next_pos = math.min(line_count, row + half_height)
    nvim.win_set_cursor(0, { next_pos, col })
  else
    local next_pos = math.max(1, row - half_height)
    nvim.win_set_cursor(0, { next_pos, col })
  end
end

set("n", "<C-d>", function()
  scroll_half_page("down")
end)

set("n", "<C-u>", function()
  scroll_half_page("up")
end)
