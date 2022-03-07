local M = {}
local action_state = require("telescope.actions.state")

M.clear_line = function(prompt_bufnr)
	local current_picker = action_state.get_current_picker(prompt_bufnr)
	current_picker:reset_prompt()
end

M.expand_snippet = function()
	local selection = action_state.get_selected_entry()
	print(vim.inspect(selection))
	require("luasnip").lsp_expand(selection.value)
end

return M
