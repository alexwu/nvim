vim.g.do_filetype_lua = 1
vim.g.did_load_filetypes = 0

vim.filetype.add({
	filename = {
		[".git/config"] = "gitconfig",
		["dot_gitconfig"] = "gitconfig",
		["dot_config/git/ignore"] = "gitconfig",
		["dot_zshrc"] = "zsh",
		["dot_vimrc"] = "vim",
		[".zimrc"] = "zsh",
		["private_dot_zimrc"] = "zsh",
	},
	pattern = {
		[".env.*"] = function(path, bufnr, ext)
			return "sh"
		end,
	},
})
