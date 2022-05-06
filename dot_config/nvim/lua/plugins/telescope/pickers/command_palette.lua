local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local custom_actions = require("plugins.telescope.actions")
local finders = require("telescope.finders")
local make_entry = require("telescope.make_entry")
local pickers = require("telescope.pickers")
local sorters = require("telescope.sorters")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local filter = vim.tbl_filter

local M = {}

M.command_palette = function(opts)
	opts = opts or {}

	local favorites = opts.favorites or {}

	opts.bufnr = vim.api.nvim_get_current_buf()
	opts.winnr = vim.api.nvim_get_current_win()
	opts.ft = vim.bo.ft

	pickers.new(opts, {
		prompt_title = "Command Palette",
		finder = require("plugins.telescope.finders").command_finder(),
		-- finder = finders.new_table({
		-- 	results = favorites,
		-- 	entry_maker = function(entry)
		-- 		return {
		-- 			value = entry,
		-- 			text = entry.name,
		-- 			display = entry.name,
		-- 			ordinal = entry.name,
		-- 			filename = nil,
		-- 		}
		-- 	end,
		-- }),
		previewer = false,
		sorter = conf.generic_sorter(opts),
		attach_mappings = function(_)
			actions.select_default:replace(function(_)
				local selection = action_state.get_selected_entry()
				if not selection then
					vim.notify("[telescope] Nothing currently selected")
					return
				end

				selection.value.callback(opts)
			end)
			return true
		end,
	}):find()
end
