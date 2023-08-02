local bin = "/opt/homebrew/bin/"

vim.o.autoindent = true
vim.o.ch = 2
vim.o.confirm = true
vim.o.ignorecase = true
vim.o.backspace = "indent,eol,start"
vim.o.cmdheight = 1
vim.o.cursorline = true
vim.o.directory = "~/.vim-tmp/,~/.tmp/,~/tmp/,/var/tmp/,/tmp"
vim.o.mouse = "nvi"
vim.o.mousemodel = "popup_setpos"
vim.o.updatetime = 250
vim.o.hlsearch = true
vim.o.expandtab = true
vim.o.incsearch = true
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.modelines = 1
vim.o.backup = false
vim.o.swapfile = false
vim.o.writebackup = true
vim.o.joinspaces = false
vim.o.showmode = false
vim.o.wrap = false
vim.o.number = true
vim.o.numberwidth = 5
vim.o.ruler = true
vim.o.scrolloff = 5
vim.o.shiftwidth = 2
vim.o.showcmd = true
vim.o.signcolumn = "yes:1"
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.textwidth = 0
vim.o.tags = "./TAGS,TAGS"
vim.o.wildignore = "*.swp,.git,.svn,*.log,*.gif,*.jpeg,*.jpg,*.png,*.pdf,tmp/**,.DS_STORE,.DS_Store"
vim.opt.shortmess:append("Icq")
vim.o.termguicolors = true
vim.o.timeoutlen = 500
vim.o.pumheight = 10
vim.o.guifont = "FiraCode Nerd Font:h14"
vim.o.fillchars = "foldclose:,foldopen:"
vim.g.ts_highlight_lua = false
vim.o.conceallevel = 2
-- vim.o.splitkeep="screen"
-- vim.opt.foldopen:remove({ "hor" })
vim.o.conceallevel = 2

vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

vim.cmd([[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-1-
]])

-- disable python 2
vim.g.loaded_python_provider = 0
vim.g["python3_host_prog"] = bin .. "python3"
