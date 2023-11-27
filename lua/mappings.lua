local utils = require("bombeelu.utils")
local bu = require("bu")
local keys = bu.keys
local ex = utils.ex
local lazy = utils.lazy
local repeatable = bu.nvim.repeatable
local api = vim.api

vim.g.mapleader = " "

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

key.map("<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
key.map("<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

set("n", "<ESC>", ex("noh"))
set("x", "<F2>", '"*y', { desc = "Copy to system clipboard" })
set("n", "<A-BS>", "db", { desc = "Delete previous word" })
set("i", "<A-BS>", "<C-W>", { desc = "Delete previous word" })

set("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Open Location List" })
set("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Open Quickfix List" })

set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

set("n", "Q", lazy(vim.cmd.quit))

set(
  "n",
  { "<A-o>" },
  repeatable(function()
    keys.o({ esc = true })
  end),
  { desc = "Add a new line below the current line" }
)

set(
  "n",
  { "<A-O>" },
  repeatable(function()
    keys.O({ esc = true })
  end),
  { desc = "Add a new line above the current line" }
)

---@class ScrollHalfPageOpts
---@field bufnr? number

---@param dir "up" | "down"
---@param opts? ScrollHalfPageOpts
local function scroll_half_page(dir, opts)
  opts = vim.F.if_nil(opts, {})
  local bufnr = vim.F.if_nil(opts.bufnr, api.nvim_get_current_buf())
  local line_count = api.nvim_buf_line_count(bufnr)
  local height = api.nvim_win_get_height(0)
  local half_height = math.floor(height / 2)
  local row, col = unpack(api.nvim_win_get_cursor(0))

  if dir == "down" then
    local next_pos = math.min(line_count, row + half_height)
    api.nvim_win_set_cursor(0, { next_pos, col })
  else
    local next_pos = math.max(1, row - half_height)
    api.nvim_win_set_cursor(0, { next_pos, col })
  end
end

set("n", "<C-d>", function()
  scroll_half_page("down")
end, { desc = "Scroll down half page" })

set("n", "<C-u>", function()
  scroll_half_page("up")
end, { desc = "Scroll up half page" })
