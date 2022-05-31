require("refactoring").setup({})
require("telescope").load_extension("refactoring")

vim.keymap.set(
	"v",
	"<leader>rr",
	"<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
	{ noremap = true }
)

vim.keymap.set("n", "<leader>rb", function()
	require("refactoring").refactor("Extract Block")
end, { noremap = true, silent = true, expr = false, desc = "Extract block" })

vim.keymap.set("n", "<leader>rbf", function()
	require("refactoring").refactor("Extract Block To File")
end, { noremap = true, silent = true, expr = false, desc = "Extract block" })
