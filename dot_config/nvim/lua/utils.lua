local if_nil = vim.F.if_nil
local api = vim.api

local M = {}
--
---@param install_path string
---@return boolean
M.install_packer = function(install_path)
	return vim.fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

---@param install_path string
---@return boolean
M.needs_packer = function(install_path)
	return vim.fn.empty(vim.fn.glob(install_path)) > 0
end

M.packer_bootstrap = function(install_path)
	local packer_bootstrap = nil
	if M.needs_packer(install_path) then
		packer_bootstrap = M.install_packer(install_path)
	end

	return packer_bootstrap
end

M.not_vscode = function()
	if vim.fn.exists("g:vscode") == 0 then
		return true
	else
		return false
	end
end

M.tree_width = function(percentage)
	percentage = percentage or 0.2
	return math.min(40, vim.fn.round(vim.o.columns * percentage))
end

-- NOTE: pos is currently 1 indexed cause lua. Should i handle that outside this function?
M.insert_text = function(text, pos, opts)
	opts = if_nil(opts, {})
	pos = if_nil(pos, api.nvim_win_get_cursor(0))

	local bufnr = if_nil(opts.bufnr, 0)

	api.nvim_buf_set_text(bufnr, pos[1] - 1, pos[2], pos[1] - 1, pos[2], { text })
end

return M
