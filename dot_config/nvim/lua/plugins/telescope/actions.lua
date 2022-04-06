local M = {}
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

M.clear_line = function(prompt_bufnr)
	local current_picker = action_state.get_current_picker(prompt_bufnr)
	current_picker:reset_prompt()
end

M.expand_snippet = function(prompt_bufnr)
	local selection = action_state.get_selected_entry()
	local ls = require("luasnip")

	actions.close(prompt_bufnr)

	vim.api.nvim_put({ selection.value }, "", true, true)
	if ls.expandable() then
		vim.cmd("startinsert")
		ls.expand()
		vim.cmd("stopinsert")
	end
	return true
end

return M
