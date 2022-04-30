local M = {}

return setmetatable({}, {
	__index = function(_, k)
		local has_custom, custom = pcall(require, string.format("bombeelu.lsp.%s", k))

		if M[k] then
			return M[k]
		elseif has_custom then
			return custom
		else
			vim.notify("lsp config for" .. k .. " not found", "err")
		end
	end,
})
