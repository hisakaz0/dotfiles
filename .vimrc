
" Color
colorscheme elflord
syntax enable

" general
set showmatch
set mouse=a
set nf=alpha
set backspace=indent,eol,start
set noswapfile
set confirm
set hidden
set cindent
set expandtab
set shiftwidth=2
set tabstop=2
set wildmode=longest,list
set number
set title
set list
set listchars=tab:..,trail:_,eol:§,extends:>,precedes:<,nbsp:%
set cursorline
set showcmd
set cmdheight=1
set laststatus=2
set t_Co=256
set foldmethod=indent
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set clipboard+=autoselect
set clipboard+=unnamed
set incsearch
set ignorecase
set smartcase
set magic
set pastetoggle=<F4>

" map
let mapleader=','
nmap <F1> <Nop>
imap  <Esc><Plug>(caw:i:toggle)a
nmap  <Plug>(caw:i:toggle)
vmap  <Plug>(caw:i:toggle)
nnoremap ; :
vnoremap ; :
nnoremap <silent> <F3> :IndentGuidesToggle<CR>
noremap <silent> <F2> :set hlsearch! hlsearch?<CR>
nnoremap <silent> <C-n> :bn<CR>
nnoremap <silent> <C-p> :bp<CR>
inoremap <C-s> <Esc>:w<CR>
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-s> <Esc>:w<CR>
nnoremap <C-q> <Esc>:q<CR>
inoremap <C-K> <Esc>:call CorrectCode()<CR>a
nnoremap <C-K> :call CorrectCode()<CR>
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>

" autocmd
autocmd BufEnter * :hi CursorLine ctermbg=235 guibg=DarkRed cterm=bold
autocmd BufEnter * if &filetype == '' | setlocal filetype=markdown | endif
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.coffee set ft=coffee
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.conf set ft=configuration

" Revise Indent
function! CorrectCode()
  execute ":mkview"
  execute ":normal gg=G"
  execute ":loadview"
endfunction

" Count Charactor
command! Count %s/./&/g

" NeoBundle ----------------------------------------
if has('vim_starting')
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

" Required:
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
NeoBundle 'ciaranm/inkpot'
NeoBundle 'Shougo/neocomplete.vim'
NeoBundle 'kannokanno/previm'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'tyru/caw.vim'
NeoBundle 'ap/vim-buftabline'
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'glidenote/memolist.vim'
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck

" NeoComplete --------------------------------------
"Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" Previm -------------------------------------------
let g:previm_open_cmd = 'open -a "/Applications/Google Chrome.app/"'

" MemoList -----------------------------------------
let g:memolist_path = "~/tmp/MemoList"

