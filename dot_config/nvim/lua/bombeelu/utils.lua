-- NOTE: The lazy helprs are from here: https://github.com/mrjones2014/legendary.nvim/blob/master/lua/legendary/helpers.lua
local M = {}

function M.lazy(fn, ...)
	local args = { ... }
	return function()
		fn(unpack(args))
	end
end

function M.lazy_required_fn(module_name, fn_name, ...)
	local args = { ... }
	return function()
		((_G["require"](module_name))[fn_name])(unpack(args))
	end
end

function M.map(modes, mappings, callback, opts)
	if type(mappings) == "string" then
		mappings = { mappings }
	end
	vim.tbl_map(function(mapping)
		vim.keymap.set(modes, mapping, callback, opts)
	end, mappings)
end

return M
