local api = vim.api

-- Disable unneded builtin plugins
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_netrwSettings = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1

_G.map = require("bombeelu.utils").set

-- the following is from here: https://github.com/norcalli/nvim.lua/blob/master/lua/nvim.lua
_G.nvim = setmetatable({
	buf = {
		line = api.nvim_get_current_line,
		nr = api.nvim_get_current_buf,
	},
	ex = setmetatable({}, {
		__index = function(t, k)
			local command = k:gsub("_$", "!")
			local f = function(...)
				return api.nvim_command(table.concat(vim.tbl_flatten({ command, ... }), " "))
			end
			rawset(t, k, f)
			return f
		end,
	}),
}, {
	__index = function(t, k)
		local f = api["nvim_" .. k]
		if f then
			rawset(t, k, f)
		end
		return f
	end,
})
