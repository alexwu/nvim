local locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")
local hint_with = require("hop").hint_with
local hint_with = require("hop").hint_with
local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context
local jump_target = require("hop.jump_target")
local ts = vim.treesitter

local wrap_targets = require("plugins.hop.utils").wrap_targets
local override_opts = require("plugins.hop.utils").override_opts

local function is_floating_win(winid)
  return vim.api.nvim_win_get_config(winid).relative ~= ""
end

local M = {}

local function lsp_filter_window(node, contexts, nodes_set)
  local line = node.lnum - 1
  local col = node.col
  for _, bctx in ipairs(contexts) do
    if nvim.buf_is_valid(bctx.hbuf) and bctx.hbuf == node.bufnr then
      for _, wctx in ipairs(bctx.contexts) do
        if
          nvim.win_is_valid(wctx.hwin)
          and not is_floating_win(wctx.hwin)
          and line <= wctx.bot_line
          and line >= wctx.top_line
        then
          nodes_set[line .. col] = {
            line = line,
            column = col,
            window = wctx.hwin,
            buffer = bctx.hbuf,
          }
        end
      end
    end
  end
end

local function window_context(win_handle, cursor_pos)
  -- get a bunch of information about the window and the cursor
  vim.api.nvim_set_current_win(win_handle)
  local win_info = vim.fn.getwininfo(win_handle)[1]
  local win_view = vim.fn.winsaveview()
  local top_line = win_info.topline - 1
  local bot_line = win_info.botline

  -- NOTE: due to an (unknown yet) bug in neovim, the sign_width is not correctly reported when shifting the window
  -- view inside a non-wrap window, so we can’t rely on this; for this reason, we have to implement a weird hack that
  -- is going to disable the signs while hop is running (I’m sorry); the state is restored after jump
  -- local left_col_offset = win_info.variables.context.number_width + win_info.variables.context.sign_width
  local win_width = nil

  -- hack to get the left column offset in nowrap
  if not vim.wo.wrap then
    vim.api.nvim_win_set_cursor(win_handle, { cursor_pos[1], 0 })
    local left_col_offset = vim.fn.wincol() - 1
    vim.fn.winrestview(win_view)
    win_width = win_info.width - left_col_offset
  end

  return {
    hwin = win_handle,
    cursor_pos = cursor_pos,
    top_line = top_line,
    bot_line = bot_line,
    win_width = win_width,
    col_offset = win_view.leftcol,
  }
end

local lsp_diagnostics = function(_hint_opts)
  local cur_hwin = vim.api.nvim_get_current_win()
  local cur_hbuf = vim.api.nvim_win_get_buf(cur_hwin)
  local cur_col = vim.fn.strwidth(vim.api.nvim_get_current_line():sub(1, vim.fn.col(".")))

  local context =
    { {
      hbuf = cur_hbuf,
      contexts = { window_context(cur_hwin, { vim.fn.line("."), cur_col }) },
    } }
  -- local context = get_window_context(hint_opts)
  local diagnostics = require("plugins.hop.utils").diagnostics_to_tbl()

  local out = {}
  for _, diagnostic in ipairs(diagnostics) do
    lsp_filter_window(diagnostic, context, out)
  end

  return wrap_targets(vim.tbl_values(out))
end

-- TODO: Clean this up and pull into an actual hop extension file
M.hint_diagnostics = function(opts)
  hint_with(lsp_diagnostics, override_opts(opts))
end

local function ts_filter_window(node, contexts, nodes_set)
  local line = node.lnum
  local col = node.col + 1

  for _, bctx in ipairs(contexts) do
    if bctx.hbuf == node.bufnr then
      for _, wctx in ipairs(bctx.contexts) do
        if not is_floating_win(wctx.hwin) and line <= wctx.bot_line and line >= wctx.top_line then
          nodes_set[line .. col] = {
            line = line,
            column = col,
            window = wctx.hwin,
            buffer = bctx.hbuf,
          }
        end
      end
    end
  end
end

local ts_usages = function(_hint_opts)
  local bufnr = nvim.get_current_buf()
  local node = ts_utils.get_node_at_cursor()

  local cur_hwin = vim.api.nvim_get_current_win()
  local cur_hbuf = vim.api.nvim_win_get_buf(cur_hwin)
  local cur_col = vim.fn.strwidth(vim.api.nvim_get_current_line():sub(1, vim.fn.col(".")))

  local context =
    { {
      hbuf = cur_hbuf,
      contexts = { window_context(cur_hwin, { vim.fn.line("."), cur_col }) },
    } }

  local def_node, scope = locals.find_definition(node, bufnr)
  local usages = locals.find_usages(def_node, scope, bufnr)

  local nodes = {}
  for _, usage in ipairs(usages) do
    local srow, scol, _erow, _ecol = usage:range()

    table.insert(nodes, { lnum = srow, col = scol, bufnr = cur_hbuf })
  end

  local out = {}
  for _, usage in ipairs(nodes) do
    ts_filter_window(usage, context, out)
  end

  return wrap_targets(vim.tbl_values(out))
end

local function regex_by_word_start()
  local regex = [=[\%(\%([[:upper:]][[:lower:]]\+\)\|\%([[:upper:]]\+\)\|\%([[:lower:]]\+\)\)]=]
  return jump_target.regex_by_searching(regex)
end

function M.hint_wordmotion(opts)
  opts = override_opts(opts)

  local generator
  if opts.current_line_only then
    generator = jump_target.jump_targets_for_current_line
  else
    generator = jump_target.jump_targets_by_scanning_lines
  end
  vim.pretty_print(generator(regex_by_word_start()))
  hint_with(generator(regex_by_word_start()), opts)
end

M.hint_usages = function(opts)
  hint_with(ts_usages, override_opts(opts))
end

-- TODO: function M.hint_pairs(opts) end
-- TODO: function M.hint_strings_boolean_float_etc...(opts) end

return M
