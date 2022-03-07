local M = {}
local scan = require("plenary.scandir")
local path = require("plenary.path")
local finders = require("telescope.finders")
local flatten = vim.tbl_flatten

-- TODO: combine with lsp definitions
-- TODO: Perhaps an option to have references as well?
M.related_files = function(opts)
	opts = opts or {}
	local cwd = vim.fn.expand("%:h")

	local finder = function(prompt)
		local results_path = path:new(cwd):make_relative(".")
		local finder_results = scan.scan_dir(results_path, {
			hidden = false,
		})
		return finder_results
	end

	return finders.new_table({
		results = finder("nvim"),
		entry_maker = function(entry)
			return {
				value = entry,
				display = entry,
				ordinal = entry,
			}
		end,
	})
end

M.luasnip = function(opts)
	opts = opts or {}

	local finder = function()
		return require("luasnip").available()[vim.bo.filetype]
	end

	return finders.new_table({
		results = finder(),
		entry_maker = function(entry)
			return {
				value = entry.trigger,
				display = entry.name,
				ordinal = entry,
			}
		end,
	})
end

return M
