local keys = require("bombeelu.keys")

local M = {}

local function surround_selection(mode, start_pair, end_pair, range, opts)
  opts = vim.F.if_nil(opts, {})
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local new_lines = vim.F.if_nil(opts.new_lines, false)
  local start_row = range.start_row - 1
  local start_col = range.start_col - 1
  local end_row = range.end_row - 1
  local end_col = range.end_col

  local lines
  if mode == "V" then
    lines = vim.api.nvim_buf_get_lines(opts.bufnr, start_row, end_row + 1, {})
  else
    lines = vim.api.nvim_buf_get_text(opts.bufnr, start_row, start_col, end_row, end_col, {})
  end

  if new_lines then
    table.insert(lines, 1, "")
  end

  -- TODO: This should add back the spaces
  lines[1] = string.format("%s%s", start_pair, vim.trim(lines[1]))

  if new_lines then
    table.insert(lines, "")
  end

  lines[#lines] = string.format("%s%s", lines[#lines], end_pair)

  if mode == "V" then
    vim.api.nvim_buf_set_lines(bufnr, start_row, end_row + 1, true, lines)
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

---@param pair string[]
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

---@param input String
---@param opts? { add_new_lines: boolean }
---@return string[]
local function create_tags(input, opts)
  opts = vim.F.if_nil(opts, {})
  local begin_tag = string.format("<%s>", input)
  local end_tag = string.format("</%s>", input)

  return { begin_tag, end_tag }
end

local function surround_tags()
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = vim.api.nvim_get_mode().mode
  local start_pos, end_pos = get_selection()
  local add_new_lines = start_pos[2] ~= end_pos[2]

  vim.ui.input({ prompt = "Tag:" }, function(input)
    if not input then
      return
    end

    local tags = create_tags(input)

    surround_selection(mode, tags[1], tags[2], {
      start_row = start_pos[2],
      start_col = start_pos[3],
      end_row = end_pos[2],
      end_col = end_pos[3],
    }, { bufnr = bufnr, new_lines = add_new_lines })

    keys.esc(true)
  end)
end

function M.setup()
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

  set({ "v" }, { "t" }, surround_tags, { desc = "Surround selection specified tag" })
end

return M
