local locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")
local hint_with = require("hop").hint_with
local hint_with = require("hop").hint_with
local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context
local jump_target = require("hop.jump_target")
local ts = vim.treesitter

local wrap_targets = require("hop-extensions.utils").wrap_targets
local override_opts = require("hop-extensions.utils").override_opts

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

local lsp_diagnostics = function(hint_opts)
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
  local line = node.lnum - 1
  local col = node.col
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

local get_definitions_lookup_table = ts_utils.memoize_by_buf_tick(function(bufnr)
  local definitions = M.get_definitions(bufnr)
  local result = {}

  for _, definition in ipairs(definitions) do
    for _, node_entry in ipairs(locals.get_local_nodes(definition)) do
      local scopes = locals.get_definition_scopes(node_entry.node, bufnr, node_entry.scope)
      -- Always use the highest valid scope
      local scope = scopes[#scopes]
      local node_text = ts.query.get_node_text(node_entry.node, bufnr)
      local id = locals.get_definition_id(scope, node_text)

      result[id] = node_entry
    end
  end

  return result
end)

local ts_usages = function(hint_opts)
  local bufnr = nvim.get_current_buf()
  local context = get_window_context(hint_opts)
  local node = ts_utils.get_node_at_cursor()

  -- local lookup_table = locals.get_definitions_lookup_table(bufnr)

  local definitions = locals.get_definitions(bufnr)
  for _, def in ipairs(definitions) do
    vim.pretty_print(def)
    vim.pretty_print(ts.query.get_node_text(def, bufnr))
  end

  -- local results = {}
  -- for _, scope in locals.iter_scope_tree(node, bufnr) do
  --   local usages = locals.find_usages(node, scope, bufnr)
  -- end

  -- vim.pretty_print(usages)
  -- local out = {}
  -- for _, usage in ipairs(usages) do
  --   vim.pretty_print(vim.treesitter.get_node_text(usage, vim.api.nvim_get_current_buf()))
  -- end
  --
  return {}
end

local function regex_by_word_start()
  -- local regex =
  --   [=[\%(\%([[:upper:]][[:lower:]]\+\)\|\%([[:upper:]]\+\ze[[:upper:]][[:lower:]]\)\|\%([[:upper:]]\+\)\|\%([[:lower:]]\+\)\|\%(#[[:xdigit:]]\+\>\)\|\%(\<0[xX][[:xdigit:]]\+\>\)\|\%(\<0[oO][0-7]\+\>\)\|\%(\<0[bB][01]\+\>\)\|\%([[:digit:]]\+\)\|\%(\%(\%([[:lower:][:upper:][:digit:]]\|\%(\%([[:space:]]\)\|\%(\%([[:lower:][:upper:][:digit:]]_*\)\@<=_\%(_*[[:lower:][:upper:][:digit:]]\)\@=\)\|\%(\%([[:lower:][:upper:]]-*\)\@<=-\%(-*[[:lower:][:upper:]]\)\@=\)\)\)\@![[:print:]]\)\+\)\|\%(\%^\)\|\%(\%$\)\)\+]=]
  --
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

  hint_with(generator(regex_by_word_start()), opts)
end

M.hint_usages = function(opts)
  ts_usages(opts)
  -- hint_with(ts_usages, override_opts(opts))
end

local output = vim.api.nvim_exec(
  [=[
function s:init()
	let l:_ = {}

	function l:_.get(name, default)
		let l:spaces = get(g:, a:name, a:default)
		if type(l:spaces) == type('')
			let l:spaces = split(l:spaces, '\zs')
		endif
		call uniq(sort(l:spaces))
		if has('patch-7.4.2044')
			call filter(l:spaces, {_, val -> !empty(l:val)})
		else
			call filter(l:spaces, '!empty(v:val)')
		endif
		let l:i = index(l:spaces, '\')
		if l:i != -1
			let l:spaces[l:i] = '\\'
		endif
		for l:i in range(len(l:spaces))
			if len(l:spaces[l:i]) == 1
				let l:spaces[l:i] = '\V'.l:spaces[l:i].'\m'
			endif
		endfor
		return l:spaces
	endfunction

	function l:_.or(list)
		return '\%(\%('.join(a:list, '\)\|\%(').'\)\)'
	endfunction

	function l:_.not(not)
		return '\%('.a:not.'\@!.\)'
	endfunction

	function l:_.between(s, w)
		let l:before = '\%('.a:w.a:s.'*\)\@<='
		let l:after = '\%('.a:s.'*'.a:w.'\)\@='
		return l:before.a:s.l:after
	endfunction

	" [:alpha:] and [:alnum:] are ASCII only
	let l:alpha = '[[:lower:][:upper:]]'
	let l:alnum = '[[:lower:][:upper:][:digit:]]'
	let l:ss = '[[:space:]]'

	let l:hyphen = l:_.between('-', l:alpha)
	let l:underscore = l:_.between('_', l:alnum)
	let l:spaces = l:_.get('wordmotion_spaces', [l:hyphen, l:underscore])
	let s:s = call(l:_.or, [[l:ss] + l:spaces])
	let s:S = l:_.not(s:s)

	let l:uspaces = l:_.get('wordmotion_uppercase_spaces', [])
	let s:us = call(l:_.or, [[l:ss] + l:uspaces])
	let s:uS = l:_.not(s:us)

	let l:a = l:alnum
	let l:d = '[[:digit:]]'
	let l:p = '[[:print:]]'
	let l:l = '[[:lower:]]'
	let l:u = '[[:upper:]]'
	let l:x = '[[:xdigit:]]'

	" set complement
	function l:_.C(set, ...)
		return '\%(\%('.join(a:000, '\|').'\)\@!'.a:set.'\)'
	endfunction

	let l:words = get(g:, 'wordmotion_extra', [])
	call add(l:words, l:u.l:l.'\+')              " CamelCase
	" call add(l:words, l:u.'\+\ze'.l:u.l:l)       " ACRONYMSBeforeCamelCase
	call add(l:words, l:u.'\+')                  " UPPERCASE
	call add(l:words, l:l.'\+')                  " lowercase
	" call add(l:words, '#'.l:x.'\+\>')            " #0F0F0F
	" call add(l:words, '\<0[xX]'.l:x.'\+\>')      " 0x00 0Xff
	" call add(l:words, '\<0[oO][0-7]\+\>')        " 0o00 0O77
	" call add(l:words, '\<0[bB][01]\+\>')         " 0b00 0B11
	" call add(l:words, l:d.'\+')                  " 1234 5678
	" call add(l:words, l:_.C(l:p, l:a, s:s).'\+') " other printable characters
	" call add(l:words, '\%^')                     " start of file
	" call add(l:words, '\%$')                     " end of file
	let g:word = call(l:_.or, [l:words])
endfunction

call s:init()
]=],
  true
)

return M
