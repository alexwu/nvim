local jump_target = require "hop.jump_target"
local hop = require "hop"
local hint = require "hop.hint"
local window = require "hop.window"
local M = {}

-- TODO:
function M.hint_end_words(opts)
  opts = opts
    or {
      keys = "asdghklqwertyuiopzxcvbnmfj",
      quit_key = "<Esc>",
      perm_method = require("hop.perm").TrieBacktrackFilling,
      reverse_distribution = false,
      teasing = true,
      jump_on_sole_occurrence = true,
      case_insensitive = true,
      create_hl_autocmd = true,
      current_line_only = false,
    }

  local generator = jump_target.jump_targets_by_scanning_lines

  hop.hint_with(
    generator {
      oneshot = false,
      match = function(s)
        -- return vim.regex("\\(\\k\\|\\k\\)\\+"):match_str(s)
        -- return vim.regex("\\v(\\<|>)+"):match_str(s)
        return vim.regex("\\v(_|\\{|\\}|\\(|\\)|\"|\'\\.|\\,|\\_$|\\>)+"):match_str(s)
      end,
    },
    opts
  )
end

-- Mark the current line with jump targets.
--
-- Returns the jump targets as described above.
local function mark_jump_targets_line(buf_handle, win_handle, regex, line_nr, line, col_offset, win_width, direction_mode)
  local jump_targets = {}
  local end_index = nil

  if win_width ~= nil then
    end_index = col_offset + win_width
  else
    end_index = vim.fn.strdisplaywidth(line)
  end

  local shifted_line = line:sub(1 + col_offset, vim.fn.byteidx(line, end_index))

  -- modify the shifted line to take the direction mode into account, if any
  -- FIXME: we also need to do that for the cursor
  local col_bias = 0
  if direction_mode ~= nil then
    local col = vim.fn.byteidx(line, direction_mode.cursor_col + 1)
    if direction_mode.direction == hint.HintDirection.AFTER_CURSOR then
      -- we want to change the start offset so that we ignore everything before the cursor
      shifted_line = shifted_line:sub(col - col_offset)
      col_bias = col - 1
    elseif direction_mode.direction == hint.HintDirection.BEFORE_CURSOR then
      -- we want to change the end
      shifted_line = shifted_line:sub(1, col - col_offset)
    end
  end

  local col = 1
  while true do
    local s = shifted_line:sub(col)
    local b, e = regex.match(s)

    if b == nil or (b == 0 and e == 0) then
      break
    end

    local colb = col + b
    jump_targets[#jump_targets + 1] = {
      line = line_nr,
      column = math.max(1, colb + col_offset + col_bias),
      buffer = buf_handle,
      window = win_handle,
    }

    local cole = col + e
    jump_targets[#jump_targets + 1] = {
      line = line_nr,
      column = math.max(1, cole + col_offset + col_bias),
      buffer = buf_handle,
      window = win_handle,
    }

    if regex.oneshot then
      break
    else
      col = col + e
    end
  end

  return jump_targets
end

-- Create jump targets for a given indexed line.
--
-- This function creates the jump targets for the current (indexed) line and appends them to the input list of jump
-- targets `jump_targets`.
--
-- Indirect jump targets are used later to sort jump targets by score and create hints.
local function create_jump_targets_for_line(
  buf_handle,
  win_handle,
  i,
  jump_targets,
  indirect_jump_targets,
  regex,
  top_line,
  col_offset,
  win_width,
  cursor_pos,
  direction_mode,
  lines
)
  -- first, create the jump targets for the ith line
  local line_jump_targets = mark_jump_targets_line(
    buf_handle,
    win_handle,
    regex,
    top_line + i - 1,
    lines[i],
    col_offset,
    win_width,
    direction_mode
  )

  -- then, append those to the input jump target list and create the indexed jump targets
  local win_bias = math.abs(vim.api.nvim_get_current_win() - win_handle) * 1000
  for _, current in pairs(line_jump_targets) do
    jump_targets[#jump_targets + 1] = current

    indirect_jump_targets[#indirect_jump_targets + 1] = {
      index = #jump_targets,
      score = jump_target.manh_dist(cursor_pos, { current.line, current.column }) + win_bias
    }
  end
end

-- Create jump targets by scanning lines in the currently visible buffer.
--
-- This function takes a regex argument, which is an object containing a match function that must return the span
-- (inclusive beginning, exclusive end) of the match item, or nil when no more match is possible. This object also
-- contains the `oneshot` field, a boolean stating whether only the first match of a line should be taken into account.
--
-- This function returns the lined jump targets (an array of N lines, where N is the number of currently visible lines).
-- Lines without jump targets are assigned an empty table ({}). For lines with jump targets, a list-table contains the
-- jump targets as pair of { line, col }.
--
-- In addition the jump targets, this function returns the total number of jump targets (i.e. this is the same thing as
-- traversing the lined jump targets and summing the number of jump targets for all lines) as a courtesy, plus «
-- indirect jump targets. » Indirect jump targets are encoded as a flat list-table containing three values: i, for the
-- ith line, j, for the rank of the jump target, and dist, the score distance of the associated jump target. This list
-- is sorted according to that last dist parameter in order to know how to distribute the jump targets over the buffer.
function M.jump_targets_by_scanning_lines(regex)
  return function(opts)
    -- get the window context; this is used to know which part of the visible buffer is to hint
    local all_ctxs = window.get_window_context(opts.multi_windows)
    local jump_targets = {}
    local indirect_jump_targets = {}

    -- Iterate all buffers
    for _, bctx in ipairs(all_ctxs) do
      -- Iterate all windows of a same buffer
      for _, wctx in ipairs(bctx.contexts) do
        window.clip_window_context(wctx, opts.direction)
        local lines = vim.api.nvim_buf_get_lines(bctx.hbuf, wctx.top_line, wctx.bot_line + 1, false)

        -- in the case of a direction, we want to treat the first or last line (according to the direction) differently
        if opts.direction == hint.HintDirection.AFTER_CURSOR then
          -- the first line is to be checked first
          create_jump_targets_for_line(
            bctx.hbuf,
            wctx.hwin,
            1,
            jump_targets,
            indirect_jump_targets,
            regex,
            wctx.top_line,
            wctx.col_offset,
            wctx.win_width,
            wctx.cursor_pos,
            { cursor_col = wctx.cursor_pos[2], direction = opts.direction },
            lines
          )

          for i = 2, #lines do
            create_jump_targets_for_line(
              bctx.hbuf,
              wctx.hwin,
              i,
              jump_targets,
              indirect_jump_targets,
              regex,
              wctx.top_line,
              wctx.col_offset,
              wctx.win_width,
              wctx.cursor_pos,
              nil,
              lines
            )
          end
        elseif opts.direction == hint.HintDirection.BEFORE_CURSOR then
          -- the last line is to be checked last
          for i = 1, #lines - 1 do
            create_jump_targets_for_line(
              bctx.hbuf,
              wctx.hwin,
              i,
              jump_targets,
              indirect_jump_targets,
              regex,
              wctx.top_line,
              wctx.col_offset,
              wctx.win_width,
              wctx.cursor_pos,
              nil,
              lines
            )
          end

          create_jump_targets_for_line(
            bctx.hbuf,
            wctx.hwin,
            #lines,
            jump_targets,
            indirect_jump_targets,
            regex,
            wctx.top_line,
            wctx.col_offset,
            wctx.win_width,
            wctx.cursor_pos,
            { cursor_col = wctx.cursor_pos[2], direction = opts.direction },
            lines
          )
        else
          for i = 1, #lines do
            create_jump_targets_for_line(
              bctx.hbuf,
              wctx.hwin,
              i,
              jump_targets,
              indirect_jump_targets,
              regex,
              wctx.top_line,
              wctx.col_offset,
              wctx.win_width,
              wctx.cursor_pos,
              nil,
              lines
            )
          end
        end

      end
    end

    jump_target.sort_indirect_jump_targets(indirect_jump_targets, opts)

    return { jump_targets = jump_targets, indirect_jump_targets = indirect_jump_targets }
  end
end

-- Jump target generator for regex applied only on the cursor line.
function M.jump_targets_for_current_line(regex)
  return function(opts)
    local context = window.get_window_context(false)[1].contexts[1]
    local line_n = context.cursor_pos[1]
    local line = vim.api.nvim_buf_get_lines(0, line_n - 1, line_n, false)
    local jump_targets = {}
    local indirect_jump_targets = {}

    create_jump_targets_for_line(
      0,
      0,
      1,
      jump_targets,
      indirect_jump_targets,
      regex,
      line_n - 1,
      context.col_offset,
      context.win_width,
      context.cursor_pos,
      { cursor_col = context.cursor_pos[2], direction = opts.direction },
      line
    )

    jump_target.sort_indirect_jump_targets(indirect_jump_targets, opts)

    return { jump_targets = jump_targets, indirect_jump_targets = indirect_jump_targets }
  end
end

function M.hint_both_ends()
  local generator = M.jump_targets_by_scanning_lines

  hop.hint_with(
    generator(jump_target.regex_by_searching('\\k\\+'))
  )
end
return M
