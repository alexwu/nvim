local utils = require("bombeelu.utils")
local bu = require("bu")
local keys = bu.keys
local ex = utils.ex
local lazy = utils.lazy
local repeatable = bu.nvim.repeatable
local api = vim.api

vim.g.mapleader = " "

set("n", { "j", "<Down>" }, 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"', { expr = true, desc = "Move down a line" })

set("n", { "k", "<Up>" }, 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"', { expr = true, desc = "Move up a line" })

set("x", { "<" }, "<gv", { desc = "De-dent selection" })
set("x", { ">", "<Tab>" }, ">gv", { desc = "Indent selection" })

set("n", "<ESC>", ex("noh"))
set("n", { "<C-s>", "<D-s>" }, vim.cmd.write, { desc = "Save file" })
set("x", "<F2>", '"*y', { desc = "Copy to system clipboard" })
set("n", "<F3>", [[<cmd>let @+ = fnamemodify(expand('%'), ':.')<CR>]], { desc = "Copy path to current buffer to system clipboard" })
set("n", "<A-BS>", "db", { desc = "Delete previous word" })
set("i", "<A-BS>", "<C-W>", { desc = "Delete previous word" })

set("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

set("n", "Q", lazy(vim.cmd.quit))

set("n", "]t", vim.cmd.tabnext, { desc = "Next tab" })
set("n", "[t", vim.cmd.tabprevious, { desc = "Previous tab" })

set(
  "n",
  { "<A-o>", "<D-CR>" },
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
  opts = opts or {}
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

set({ "n", "v" }, "<C-d>", function()
  scroll_half_page("down")
end, { desc = "Scroll down half page" })

set({ "n", "v" }, "<C-u>", function()
  scroll_half_page("up")
end, { desc = "Scroll up half page" })
