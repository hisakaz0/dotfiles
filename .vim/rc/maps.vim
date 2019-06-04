
let mapleader=','

nnoremap <F1> <Nop>
inoremap <F1> <Nop>
inoremap <C-s> <Esc>:w<CR>
nnoremap <C-s> <Esc>:w<CR>

" search in magic mode
nnoremap / /\v
nnoremap ? ?\v

" buffer moving
nnoremap <silent> <C-n> :bn<CR>
nnoremap <silent> <C-p> :bp<CR>

" cursor moving
inoremap <C-E> <C-X><C-E>
inoremap <C-Y> <C-X><C-Y>

" tabpage moving
nnoremap <k0> :tabn<CR>
nnoremap <k1> :tabp<CR>
nnoremap <Leader>tabn :tabn<CR>
nnoremap <Leader>tabp :tabp<CR>
nnoremap <Leader>tabs :tab split<CR>

" quickfix
nnoremap <silent> <Leader>cn :cn<CR>
nnoremap <silent> <Leader>cp :cp<CR>
nnoremap <silent> <Leader>cc :cc<CR>

" options 
nnoremap <silent> <Leader>hls :set invhlsearch<CR>
nnoremap <silent> <Leader>wrap :set invwrap<CR>

