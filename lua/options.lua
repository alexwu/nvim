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
-- vim.o.updatetime = 250
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
vim.opt.shiftround = true -- Round indent
vim.o.showcmd = true
vim.o.signcolumn = "yes:2"
-- vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smarttab = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.textwidth = 0
vim.o.tags = "./TAGS,TAGS"
vim.o.wildignore = "*.swp,.git,.svn,*.log,*.gif,*.jpeg,*.jpg,*.png,*.pdf,tmp/**,.DS_STORE,.DS_Store"
vim.opt.shortmess:append("Icq")
vim.o.termguicolors = true
vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]

-- vim.o.timeoutlen = 500
vim.o.pumheight = 10
vim.o.guifont = "FiraCode Nerd Font:h14"
vim.g.ts_highlight_lua = false
vim.o.conceallevel = 2
vim.o.grepformat = "%f:%l:%c:%m"
vim.o.grepprg = "rg --vimgrep"
vim.o.splitkeep = "screen"
vim.o.splitright = true
-- vim.opt.foldopen:remove({ "hor" })
vim.o.conceallevel = 2
vim.o.smoothscroll = true

-- Folding
vim.o.foldenable = true
vim.opt.foldlevel = 99

vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }

vim.opt.foldtext = ""
-- vim.o.fillchars = "foldclose:,foldopen:,fold: "
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

vim.opt.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200 -- Save

vim.o.foldcolumn = "1"

vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "YankHighlight",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 150 })
  end,
})

-- aunmenu PopUp.-2-
vim.cmd([[
  aunmenu PopUp.How-to\ disable\ mouse
  aunmenu PopUp.-1-
]])

-- disable python 2
vim.g.loaded_python_provider = 0
vim.g["python3_host_prog"] = bin .. "python3"
