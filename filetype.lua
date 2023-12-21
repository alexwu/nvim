vim.filetype.add({
  extension = {
    rbi = "ruby",
  },
  filename = {
    [".cargo/config"] = "toml",
    [".git/config"] = "gitconfig",
    ["dot_gitconfig"] = "gitconfig",
    ["dot_config/git/ignore"] = "gitconfig",
    ["dot_zshrc"] = "zsh",
    ["dot_vimrc"] = "vim",
    [".zimrc"] = "zsh",
    ["private_dot_zimrc"] = "zsh",
    Justfile = "just",
    justfile = "just",
  },
  pattern = {
    [".env.*"] = function(path, bufnr, ext)
      return "sh"
    end,
    ["*.js.es6"] = function()
      return "javascript"
    end,
  },
})
