
" if &filetype != 'markdown'
  " inoremap <silent> ###  <C-R>=CommentBlock(input("Enter comment: "),'##','#')<CR>
  " inoremap <silent> ---  <C-R>=CommentBlock(input("Enter comment: "),'--','*')<CR>
" endif

" au BufRead * if &filetype != 'markdown' inoremap <silent> ###  <C-R>=CommentBlock(input("Enter comment: "),'##','#')<CR>
" au BufRead * if &filetype != 'markdown' inoremap <silent> ---  <C-R>=CommentBlock(input("Enter comment: "),'--','*')<CR>
