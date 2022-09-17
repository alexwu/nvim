" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Move between splits with CTRL+Arrow Keys
nnoremap <C-j> <C-W><C-J>
nnoremap <C-k> <C-W><C-K>
nnoremap <C-l> <C-W><C-L>
nnoremap <C-h> <C-W><C-H>

inoremap <c-j> <Down>
inoremap <c-k> <Up>
inoremap <c-h> <Left>
inoremap <c-l> <Right>

vnoremap <c-j> 5gj
vnoremap <c-k> 5gk
vnoremap <c-h> 5h
vnoremap <c-l> 5l

" Map :W to :w so vim stops complaining about W
command! W :w
command! Q :q
command! QW :wq
command! Qw :wq
command! WQ :wq
command! Wq :wq

map <space> <leader>

xmap <C-_> <Plug>VSCodeCommentary
omap <C-_> <Plug>VSCodeCommentary
nmap <C-_> <Plug>VSCodeCommentaryCommentaryLine

map <leader>y <Cmd>call VSCodeNotify("editor.action.formatDocument") <CR>
map <C-S-P> <Cmd>call VSCodeNotifyVisual("workbench.action.showCommands", 1)<CR>
