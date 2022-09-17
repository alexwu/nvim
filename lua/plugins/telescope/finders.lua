local M = {}
local scan = require("plenary.scandir")
local Path = require("plenary.path")
local finders = require("telescope.finders")

M.related_files = require("plugins.telescope.finders.related_files")

M.luasnip = require("plugins.telescope.finders.luasnip")

-- @class Command
-- @field name string
-- @field command function
local command = {}

-- @class Group
-- @field name string
-- @field children table

-- @param entry Group | Command
local entry_maker = function(entry) end

M.command_files = function(opts)
	opts = opts or {}
	local cwd = vim.fn.expand("%:h")

	opts.commands = {
		type = "",
	}

	local finder = function(prompt)
		local results_path = Path:new(cwd):make_relative(".")
		local finder_results = scan.scan_dir(results_path, {
			hidden = false,
		})
		return finder_results
	end

	return finders.new_table({
		results = finder("fuuu"),
		entry_maker = function(entry)
			return {
				value = entry,
				display = entry,
				ordinal = entry,
			}
		end,
	})
end

return M
