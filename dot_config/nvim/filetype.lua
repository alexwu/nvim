vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.filetype.add({
	filename = {
		[".git/config"] = "gitconfig",
		["dot_zshrc"] = "zsh",
	},
	pattern = {
		[".env.*"] = function(path, bufnr, ext)
			return "sh"
		end,
	},
})
