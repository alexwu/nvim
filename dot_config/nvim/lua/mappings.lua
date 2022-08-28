local utils = require("bombeelu.utils")
local keys = require("bombeelu.keys")
local set = utils.set
local ex = utils.ex
local lazy = utils.lazy
local repeatable = require("bombeelu.repeat").mk_repeatable

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

key.map("gs", [[:%s/\<<C-R><C-W>\>\C//g<left><left>]], { modes = { "n" } })

set({ "n" }, "<C-j>", "<C-w><C-j>")
set({ "n" }, "<C-h>", "<C-w><C-h>")
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

set("n", "]t", "gt")
set("n", "[t", "gT")
set("n", "Q", lazy(vim.cmd.quit))

set("n", "<A-o>", "o<esc>")
set("n", "<A-O>", "O<esc>")

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

set({ "v" }, { "q" }, function()
  surround_mapping({ [["]], [["]] })
end, { desc = "Surround selection with double quotes" })

set({ "v" }, { [[']] }, function()
  surround_mapping({ "'", "'" })
end, { desc = "Surround selection with single quotes" })

set({ "v" }, { [[`]], [[`]] }, function()
  surround_mapping({ "`", "`" })
end, { desc = "Surround selection with backtick" })
