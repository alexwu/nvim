vim.filetype.add({
	filename = {
		[".git/config"] = "gitconfig",
		["dot_zshrc"] = "zsh",
	},
})
require("impatient")
require("options")
require("mappings")
require("globals")
require("plugins")

require("snazzy").setup("dark")

require("plugins.treesitter")

vim.cmd([[autocmd BufWritePost ~/.local/share/chezmoi/* ! chezmoi apply --source-path "%"]])
