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
  -- vim.cmd.SatelliteRefresh()
end)

set({ "n" }, "<C-h>", function()
  keys.feed({ "<C-w>", "<C-h>" })
  -- vim.cmd.SatelliteRefresh()
  -- vim.pretty_print("done")
end)

-- set({ "n" }, "<C-h>", "<C-w><C-h>")
set({ "n" }, "<C-k>", "<C-w><C-k>")
set({ "n" }, "<C-l>", "<C-w><C-l>")

set({ "x" }, "<C-j>", "5gj", { desc = "Move down 5 display lines" })
set({ "x" }, "<C-k>", "5gk", { desc = "Move up 5 display lines" })
set({ "x" }, "<C-h>", "5h", { desc = "Move left 5 columns" })
set({ "x" }, "<C-l>", "5l", { desc = "Move right 5 columns" })

set({ "i" }, "<C-j>", "<Down>", { desc = "Move down a  line" })
set({ "i" }, "<C-k>", "<Up>", { desc = "Move up a line" })
set({ "i" }, "<C-h>", "<Left>", { desc = "Move left a column" })
set({ "i" }, "<C-l>", "<Right>", { desc = "Move right a column" })

set("n", "<ESC>", ex("noh"))
set("x", "<F2>", '"*y', { desc = "Copy to system clipboard" })
set("n", "<A-BS>", "db", { desc = "Delete previous word" })
set("i", "<A-BS>", "<C-W>", { desc = "Delete previous word" })

set("n", "tt", lazy(vim.cmd.tabnew), { desc = "Create a new tab" })
set("n", "tq", lazy(vim.cmd.tabclose), { desc = "Close the current tab" })

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
