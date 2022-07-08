local locals = require("nvim-treesitter.locals")
local ts_utils = require("nvim-treesitter.ts_utils")
local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context
local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context
local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context
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

local lsp_diagnostics = function(hint_opts)
  local context = get_window_context(hint_opts)
  local diagnostics = require("plugins.hop.utils").diagnostics_to_tbl()

  local out = {}
  for _, diagnostic in ipairs(diagnostics) do
    lsp_filter_window(diagnostic, context, out)
  end

  return wrap_targets(vim.tbl_values(out))
end

-- TODO: Clean this up and pull into an actual hop extension file
M.hint_diagnostics = function(opts)
  -- TODO: mirror goto_next and show the popup
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

  local lookup_table = locals.get_definitions_lookup_table(bufnr)

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

M.hint_usages = function(opts)
  ts_usages(opts)
  -- hint_with(ts_usages, override_opts(opts))
end

return M
