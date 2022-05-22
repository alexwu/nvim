local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context
local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context
local hint_with = require("hop").hint_with
local get_window_context = require("hop.window").get_window_context

local wrap_targets = require("hop-extensions.utils").wrap_targets
local override_opts = require("hop-extensions.utils").override_opts

local M = {}

local function lsp_filter_window(node, contexts, nodes_set)
	local line = node.lnum - 1
	local col = node.col
	for _, bctx in ipairs(contexts) do
		if bctx.hbuf == node.bufnr then
			for _, wctx in ipairs(bctx.contexts) do
				if line <= wctx.bot_line and line >= wctx.top_line then
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

return M
