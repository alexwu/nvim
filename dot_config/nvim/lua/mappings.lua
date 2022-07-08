local utils = require("bombeelu.utils")
local keys = require("bombeelu.keys")
local set = utils.set
local ex = utils.ex
local repeatable = require("bombeelu.repeat").mk_repeatable

vim.g.mapleader = " "

set(
  "n",
  "]t",
  repeatable(function()
    nvim.feedkeys("gt", "n", true)
  end)
)
set("n", "j", "gj", { desc = "Move down a display line" })
set("n", "k", "gk", { desc = "Move up a display line" })

set({ "x" }, "<C-j>", "5gj", { desc = "Move down 5 display lines" })
set({ "x" }, "<C-k>", "5gk", { desc = "Move up 5 display lines" })
set({ "x" }, "<C-h>", "5h", { desc = "Move left 5 columns" })
set({ "x" }, "<C-l>", "5l", { desc = "Move right 5 columns" })

set({ "n", "i" }, "<C-j>", "<Down>", { desc = "Move down a  line" })
set({ "n", "i" }, "<C-k>", "<Up>", { desc = "Move up a line" })
set({ "n", "i" }, "<C-h>", "<Left>", { desc = "Move left a column" })
set({ "n", "i" }, "<C-l>", "<Right>", { desc = "Move right a column" })

set("n", "<ESC>", ex("noh"))
set("x", "<F2>", '"*y', { desc = "Copy to system clipboard" })
set("n", "<A-BS>", "db", { desc = "Delete previous word" })
set("i", "<A-BS>", "<C-W>", { desc = "Delete previous word" })

set("n", "tt", ex("tabnew"), { desc = "Create a new tab" })
set("n", "tq", ex("tabclose"), { desc = "Close the current tab" })
-- set("n", "]t", "gt")
set("n", "[t", "gT")
set("n", "Q", ex("quit"))

set("n", "<A-o>", "o<esc>")
set("n", "<A-O>", "O<esc>")

set("n", "gg", "gg", {
  desc = "Go to first line",
})

local ts = require("vim.treesitter")
local ts_utils = require("nvim-treesitter.ts_utils")
local function surround_node(start_text, end_text, node, bufnr)
  if not node then
    return
  end

  local start_row, start_col, end_row, end_col = node:range()
  local lines = vim.api.nvim_buf_get_text(bufnr, start_row, start_col, end_row, end_col, {})

  -- local lines = vim.split(ts.get_node_text(node, bufnr), "\n")
  lines[1] = string.format("%s%s", start_text, lines[1])
  lines[#lines] = string.format("%s%s", lines[#lines], end_text)

  vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, lines)
end

local function surround_selection(mode, start_pair, end_pair, range, opts)
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local start_row = range.start_row - 1
  local start_col = range.start_col - 1
  local end_row = range.end_row - 1
  local end_col = range.end_col

  local lines
  if mode == "V" then
    lines = vim.api.nvim_buf_get_lines(opts.bufnr, range.start_row, range.end_row, {})
  else
    lines = vim.api.nvim_buf_get_text(opts.bufnr, start_row, start_col, end_row, end_col, {})
  end

  lines[1] = string.format("%s%s", start_pair, lines[1])
  lines[#lines] = string.format("%s%s", lines[#lines], end_pair)

  if mode == "V" then
    vim.api.nvim_buf_set_lines(bufnr, start_row, end_row, true, lines)
  else
    vim.api.nvim_buf_set_text(bufnr, start_row, start_col, end_row, end_col, lines)
  end
end

local function get_selection()
  local mode = vim.api.nvim_get_mode().mode
  if mode ~= "v" and mode ~= "V" then
    return
  end

  local positions = {
    vim.fn.getpos("v"),
    vim.fn.getpos("."),
  }

  table.sort(positions, function(a, b)
    if mode == "v" and a[2] == b[2] then
      return a[3] < b[3]
    end

    return a[2] < b[2]
  end)

  return positions[1], positions[2]
end

local function surround_mapping(pair)
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = vim.api.nvim_get_mode().mode
  local start_pos, end_pos = get_selection()

  surround_selection(mode, pair[1], pair[2], {
    start_row = start_pos[2],
    start_col = start_pos[3],
    end_row = end_pos[2],
    end_col = end_pos[3],
  }, { bufnr = bufnr })

  -- This puts it into normal mode afterwards. Config option?
  keys.esc(true)
end

set({ "v" }, { "(", ")" }, function()
  surround_mapping({ "(", ")" })
end, { desc = "Surround selection with parentheses" })

set({ "v" }, { "{", "}" }, function()
  surround_mapping({ "{", "}" })
end, { desc = "Surround selection with curly braces" })

set({ "v" }, { "[", "]" }, function()
  surround_mapping({ "[", "]" })
end, { desc = "Surround selection with square brackets" })
