vim.filetype.add({
  extension = {
    rbi = "ruby",
    ["http"] = "http",
    ["d.tl"] = "teal",
    psc = "papyrus",
  },
  filename = {
    [".cargo/config"] = "toml",
    [".git/config"] = "gitconfig",
    ["dot_gitconfig"] = "gitconfig",
    ["dot_config/git/ignore"] = "gitconfig",
    ["dot_zshrc"] = "zsh",
    ["dot_zprofile"] = "zsh",
    ["dot_vimrc"] = "vim",
    ["dot_ideavimrc"] = "vimrc",
    [".zimrc"] = "zsh",
    ["private_dot_zimrc"] = "zsh",
    Justfile = "just",
    justfile = "just",
    Modelfile = "modelfile",
    modefile = "modelfile",
  },
  pattern = {
    [".env.*"] = function(path, bufnr, ext)
      return "sh"
    end,
    ["*.js.es6"] = function()
      return "javascript"
    end,
    [".*/%.github[%w/]+workflows[%w/]+.*%.ya?ml"] = "yaml.github",
  },
})
