local bin = "/opt/homebrew/bin/"

vim.opt.autoindent = true
vim.opt.ch = 2
vim.opt.confirm = true
vim.opt.ignorecase = true
vim.opt.lazyredraw = true
vim.opt.backspace = "indent,eol,start"
vim.opt.cmdheight = 1
vim.opt.cursorline = true
vim.opt.directory = "~/.vim-tmp/,~/.tmp/,~/tmp/,/var/tmp/,/tmp"
vim.opt.mouse = "ar"
vim.opt.mousemodel = "popup_setpos"
vim.opt.updatetime = 250
vim.opt.hlsearch = true
vim.opt.expandtab = true
vim.opt.incsearch = true
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.modelines = 1
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.writebackup = true
vim.opt.joinspaces = false
vim.opt.showmode = false
vim.opt.wrap = false
vim.opt.number = true
vim.opt.numberwidth = 5
vim.opt.ruler = true
vim.opt.scrolloff = 5
vim.opt.shiftwidth = 2
vim.opt.showcmd = true
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smarttab = true
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.textwidth = 0
vim.opt.tags = "./TAGS,TAGS"
vim.opt.wildignore = "*.swp,.git,.svn,*.log,*.gif,*.jpeg,*.jpg,*.png,*.pdf,tmp/**,.DS_STORE,.DS_Store"
vim.opt.shortmess:append("Icq")
vim.opt.termguicolors = true
vim.opt.timeoutlen = 500
vim.opt.pumheight = 10
vim.opt.guifont = "FiraCode Nerd Font:h14"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = vim.fn["nvim_treesitter#foldexpr"]()
vim.opt.splitright = true

vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- disable python 2
vim.g.loaded_python_provider = 0
vim.g["python3_host_prog"] = bin .. "python3"
