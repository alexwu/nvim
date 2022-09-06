local u = require("bombeelu.utils")

local M = {}

-- WARN: I have disabled this for visual line mode right now because it's a pain
function M.setup()
  set("x", "<C-r>", function()
    -- M.extract_selection()
    -- vim.pretty_print(vim.fn.getpos("."))
    -- vim.pretty_print(vim.fn.getpos("v"))
    -- vim.pretty_print(vim.fn.col({ 14, "$" }))
    M.visual_line_selection()
  end)
end

function M.extract_selection()
  local selection = u.get_selection_range()
  local selected_text = u.get_visual_selection()

  vim.pretty_print(selection)

  vim.ui.input({ prompt = "Enter variable name:" }, function(input)
    if input == nil then
      return
    end

    local name = input

    vim.ui.input({ prompt = "line number:" }, function(line_nr)
      if line_nr == nil then
        return
      end

      line_nr = tonumber(line_nr)

      vim.api.nvim_buf_set_text(
        0,
        selection.start_row,
        selection.start_col,
        selection.end_row,
        selection.end_col + 1,
        { input }
      )

      local variable = M.generate_extracted_variable(name, selected_text)
      vim.api.nvim_buf_set_lines(0, line_nr, line_nr, true, vim.split(variable, "\n"))
    end)
  end)
end

function M.visual_line_selection()
  if vim.api.nvim_get_mode().mode == "V" then
    local pos1 = vim.fn.getpos(".")
    local pos2 = vim.fn.getpos("v")
    local line_nrs = { pos1[2] - 1, pos2[2] - 1 }

    table.sort(line_nrs)
    vim.pretty_print(line_nrs)

    local selection = vim.api.nvim_buf_get_lines(0, line_nrs[1], line_nrs[2], true)
    vim.pretty_print(selection)
    return selection
  end
end

function M.generate_extracted_variable(name, text, opts)
  return string.format("local %s = %s", name, text)
end

M.setup()

return M
