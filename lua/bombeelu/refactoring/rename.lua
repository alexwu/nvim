local ts_utils = require("nvim-treesitter.ts_utils")
local locals = require("nvim-treesitter.locals")
local utils = require("nvim-treesitter.utils")
local ts = vim.treesitter
local api = vim.api

local M = {}

local function find_nodes_to_rename(node_at_point, bufnr)
  local definition, scope = locals.find_definition(node_at_point, bufnr)
  local nodes_to_rename = {}
  nodes_to_rename[node_at_point:id()] = node_at_point
  nodes_to_rename[definition:id()] = definition

  for _, n in ipairs(locals.find_usages(definition, scope, bufnr)) do
    nodes_to_rename[n:id()] = n
  end

  return nodes_to_rename
end

local function generate_edits(nodes_to_rename, new_name)
  local edits = {}

  for _, node in pairs(nodes_to_rename) do
    local lsp_range = ts_utils.node_to_lsp_range(node)
    local text_edit = { range = lsp_range, newText = new_name }
    table.insert(edits, text_edit)
  end

  return edits
end

function M.ts_rename(bufnr)
  bufnr = bufnr or api.nvim_get_current_buf()
  local node_at_point = ts_utils.get_node_at_cursor()

  local function complete_rename(new_name)
    if not new_name or #new_name < 1 then
      return
    end

    local nodes_to_rename = find_nodes_to_rename(node_at_point, bufnr)
    local edits = generate_edits(nodes_to_rename, new_name)

    vim.lsp.util.apply_text_edits(edits, bufnr, "utf-8")
  end

  if not node_at_point then
    vim.notify("No node to rename!")
    return
  end

  local ns = vim.api.nvim_create_namespace("bombeelu.rename")
  local node_text = ts.query.get_node_text(node_at_point, bufnr)
  local input = {
    prompt = "New name: ",
    default = node_text or "",
    highlight = function(new_name)
      vim.pretty_print(new_name)
      M.ts_rename_preview({ args = new_name, bufnr = bufnr, node = node_at_point }, ns, nil)
      return {}
    end,
  }

  vim.ui.input(input, complete_rename)
end

function M.ts_rename_preview(opts, ns, preview_buf)
  local bufnr = opts.bufnr
  local node_at_point = opts.node
  local nodes_to_rename = find_nodes_to_rename(node_at_point, bufnr)
  local new_name = opts.args
  local edits = generate_edits(nodes_to_rename, new_name)
  vim.pretty_print("hello")

  -- vim.pretty_print("preview fn")
  -- vim.pretty_print(edits)
  for i, edit in ipairs(edits) do
    vim.api.nvim_buf_add_highlight(
      bufnr,
      ns,
      "Substitute",
      edit.range.start.line,
      edit.range.start.character,
      edit.range["end"].character
    )

    vim.pretty_print(edit.range)
    vim.api.nvim_buf_set_text(
      bufnr,
      edit.range.start.line,
      edit.range.start.character,
      edit.range["end"].line,
      edit.range["end"].character,
      { edit.newText }
    )

    if preview_buf then
      vim.pretty_print(preview_buf)
      vim.api.nvim_buf_add_highlight(
        preview_buf,
        ns,
        "Substitute",
        edit.range.start.line,
        edit.range.start.character,
        edit.range["end"].character
      )

      vim.api.nvim_buf_set_text(
        preview_buf,
        edit.range.start.line,
        edit.range.start.character,
        edit.range["end"].line,
        edit.range["end"].character,
        { edit.newText }
      )
      -- vim.lsp.util.apply_text_edits(edits, preview_buf, "utf-8")
    end
  end

  if preview_buf then
    vim.lsp.util.apply_text_edits(edits, preview_buf, "utf-8")
  end

  return 2
end

local function _preview_example(opts, preview_ns, preview_buf)
  local line1 = opts.line1
  local line2 = opts.line2
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, line1 - 1, line2, false)
  local preview_buf_line = 0

  for i, line in ipairs(lines) do
    local start_idx, end_idx = string.find(line, "%s+$")

    if start_idx then
      -- Highlight the match
      vim.api.nvim_buf_add_highlight(buf, preview_ns, "Substitute", line1 + i - 2, start_idx - 1, end_idx)

      -- Add lines and set highlights in the preview buffer
      -- if inccommand=split
      if preview_buf then
        local prefix = string.format("|%d| ", line1 + i - 1)

        vim.api.nvim_buf_set_lines(preview_buf, preview_buf_line, preview_buf_line, false, { prefix .. line })
        vim.api.nvim_buf_add_highlight(
          preview_buf,
          preview_ns,
          "Substitute",
          preview_buf_line,
          #prefix + start_idx - 1,
          #prefix + end_idx
        )
        preview_buf_line = preview_buf_line + 1
      end
    end
  end

  -- Return the value of the preview type
  return 2
end

-- Called when the user is still typing the command or the command arguments
local function incremental_rename_preview(opts, preview_ns, preview_buf)
  vim.v.errmsg = ""
  -- Store the lines of the buffer at the first invocation.
  -- should_fetch_references will be reset when the command is cancelled (see setup function).
  -- if state.should_fetch_references then
  --   state.should_fetch_references = false
  --   state.err = nil
  --   fetch_lsp_references(opts.bufnr or vim.api.nvim_get_current_buf(), opts.lsp_params)
  -- end

  -- Started fetching references but the results did not arrive yet
  -- (or an error occurred while fetching them).
  -- if not state.cached_lines then
  --   return
  -- end

  local new_name = opts.args
  -- if not M.config.preview_empty_name and new_name:find("^%s*$") then
  --   return
  -- end

  local function apply_highlights_fn(bufnr, line_nr, line_info)
    local offset = 0
    local updated_line = line_info[1].text
    local highlight_positions = {}

    for _, info in ipairs(line_info) do
      updated_line = updated_line:sub(1, info.start_col + offset)
        .. new_name
        .. updated_line:sub(info.end_col + 1 + offset)

      table.insert(highlight_positions, {
        start_col = info.start_col + offset,
        end_col = info.start_col + #new_name + offset,
      })
      -- Offset by the length difference between the new and old names
      offset = offset + #new_name - (info.end_col - info.start_col)
    end

    vim.api.nvim_buf_set_lines(bufnr or opts.bufnr, line_nr, line_nr + 1, false, { updated_line })
    if preview_buf then
      vim.api.nvim_buf_set_lines(preview_buf, line_nr, line_nr + 1, false, { updated_line })
    end

    for _, hl_pos in ipairs(highlight_positions) do
      vim.api.nvim_buf_add_highlight(
        bufnr or opts.bufnr,
        preview_ns,
        M.config.hl_group,
        line_nr,
        hl_pos.start_col,
        hl_pos.end_col
      )

      if preview_buf then
        vim.api.nvim_buf_add_highlight(
          preview_buf,
          preview_ns,
          M.config.hl_group,
          line_nr,
          hl_pos.start_col,
          hl_pos.end_col
        )
      end
    end
  end

  -- state.preview_strategy.apply_highlights(state.cached_lines, apply_highlights_fn)
  -- state.preview_ns = preview_ns
  return 2
end

-- Create the user command
-- vim.api.nvim_create_user_command(
--   "TrimTrailingWhitespace",
--   trim_space,
--   { nargs = "?", range = "%", addr = "lines", preview = rename_preview }
-- )
--
return M
