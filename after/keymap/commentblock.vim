if &filetype != 'markdown'
  inoremap <silent> ###  <C-R>=CommentBlock(input("Enter comment: "),'##','#')<CR>
  inoremap <silent> ---  <C-R>=CommentBlock(input("Enter comment: "),'--','*')<CR>
endif
