" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Move up and down over screen lines instead of file lines
nnoremap j gj
nnoremap k gk
nnoremap <c-j> 5gj
nnoremap <c-k> 5gk
nnoremap <c-h> 5h
nnoremap <c-l> 5l

" Move between splits with CTRL+Arrow Keys
nnoremap <C-Down> <C-W><C-J>
nnoremap <C-Up> <C-W><C-K>
nnoremap <C-Right> <C-W><C-L>
nnoremap <C-Left> <C-W><C-H>

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
nmap <C-_> <Plug>VSCodeCommentary
nmap <C-_><C-_> <Plug>VSCodeCommentaryCommentaryLine

map <leader>y <Cmd>call VSCodeNotify("editor.action.formatDocument") <CR>
