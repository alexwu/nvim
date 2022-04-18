local set = vim.keymap.set

_G.toggleterm_strategy = function(cmd)
	require("toggleterm.terminal").Terminal
		:new({
			cmd = cmd,
			close_on_exit = false,
			hidden = true,
			direction = "float",
			float_opts = {
				border = "rounded",
				width = vim.fn.round(0.9 * vim.o.columns),
				height = vim.fn.round(0.9 * vim.o.lines),
				winblend = 15,
				highlights = { border = "FloatBorder", background = "Normal" },
			},
			on_open = function(term)
				vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
			end,
		})
		:toggle()
end

vim.cmd([[
function! ToggletermStrategy(cmd)
  let g:cmd = a:cmd . "\n"
  lua toggleterm_strategy(vim.g.cmd)
endfunction

let g:test#custom_strategies = {'toggleterm': function('ToggletermStrategy')}
]])

vim.api.nvim_set_var("test#strategy", "toggleterm")
vim.api.nvim_set_var("test#ruby#rspec#executable", "bundle exec rspec")
vim.api.nvim_set_var("test#ruby#rspec#patterns", "_spec.rb")
vim.api.nvim_set_var("test#ruby#rspec#options", {
	file = "--format documentation --force-color",
	suite = "--format documentation --force-color",
	nearest = "--format documentation --force-color",
})
vim.api.nvim_set_var("test#javascript#jest#options", "--color=always")
vim.api.nvim_set_var("test#typescript#jest#options", "--color=always")

set("n", "<F7>", "<cmd>TestNearest<CR>")
set("n", "<F9>", "<cmd>TestFile<CR>")
