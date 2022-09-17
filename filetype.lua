vim.filetype.add({
  extension = {
    rbi = "ruby",
  },
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
