vim.g.neovide_transparency = 0.95
vim.g.neovide_input_use_logo = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
vim.g.neovide_input_macos_alt_is_meta = true
vim.g.neovide_remember_window_size = true
--
-- set({ "n", "x" }, "<D-v>", [["*p]], { desc = "Paste from system clipboard" })
-- set({ "i", "c" }, "<D-v>", [[<C-r>*]], { desc = "Paste from system clipboard" })
-- set({ "n", "x" }, "<D-c>", [["*y]], { desc = "Copy from system clipboard" })

vim.cmd([[
nnoremap <special> <D-n> :confirm enew<CR>
vmap <special> <D-n> <Esc><D-n>gv
imap <special> <D-n> <C-O><D-n>
cmap <special> <D-n> <C-C><D-n>
omap <special> <D-n> <Esc><D-n>

nnoremap <special> <D-o> :browse confirm e<CR>
vmap <special> <D-o> <Esc><D-o>gv
imap <special> <D-o> <C-O><D-o>
cmap <special> <D-o> <C-C><D-o>
omap <special> <D-o> <Esc><D-o>

nnoremap <silent> <special> <D-w> :if winheight(2) < 0 <Bar> confirm enew <Bar> else <Bar> confirm close <Bar> endif<CR>
vmap <special> <D-w> <Esc><D-w>gv
imap <special> <D-w> <C-O><D-w>
cmap <special> <D-w> <C-C><D-w>
omap <special> <D-w> <Esc><D-w>

nnoremap <silent> <special> <D-s> :if expand("%") == ""<Bar>browse confirm w<Bar> else<Bar>confirm w<Bar>endif<CR>
vmap <special> <D-s> <Esc><D-s>gv
imap <special> <D-s> <C-O><D-s>
cmap <special> <D-s> <C-C><D-s>
omap <special> <D-s> <Esc><D-s>

nnoremap <special> <D-S-s> :browse confirm saveas<CR>
vmap <special> <D-S-s> <Esc><D-s>gv
imap <special> <D-S-s> <C-O><D-s>
cmap <special> <D-S-s> <C-C><D-s>
omap <special> <D-S-s> <Esc><D-s>

" From the Edit menu of SimpleText:
nnoremap <special> <D-z> u
vmap <special> <D-z> <Esc><D-z>gv
imap <special> <D-z> <C-O><D-z>
cmap <special> <D-z> <C-C><D-z>
omap <special> <D-z> <Esc><D-z>

vnoremap <special> <D-x> "+x

vnoremap <special> <D-c> "+y

cnoremap <special> <D-c> <C-Y>

nnoremap <special> <D-v> "+gP
cnoremap <special> <D-v> <C-R>+
execute 'vnoremap <script> <special> <D-v>' paste#paste_cmd['v']
execute 'inoremap <script> <special> <D-v>' paste#paste_cmd['i']

nnoremap <silent> <special> <D-a> :if &slm != ""<Bar>exe ":norm gggH<C-O>G"<Bar> else<Bar>exe ":norm ggVG"<Bar>endif<CR>
vmap <special> <D-a> <Esc><D-a>
imap <special> <D-a> <Esc><D-a>
cmap <special> <D-a> <C-C><D-a>
omap <special> <D-a> <Esc><D-a>

nnoremap <special> <D-f> /
vmap <special> <D-f> <Esc><D-f>
imap <special> <D-f> <Esc><D-f>
cmap <special> <D-f> <C-C><D-f>
omap <special> <D-f> <Esc><D-f>

nnoremap <special> <D-g> n
vmap <special> <D-g> <Esc><D-g>
imap <special> <D-g> <C-O><D-g>
cmap <special> <D-g> <C-C><D-g>
omap <special> <D-g> <Esc><D-g>
]])
