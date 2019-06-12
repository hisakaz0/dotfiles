
set showmatch
set mouse=a
set nrformats=alpha
set backspace=indent,eol,start
set noswapfile
set confirm
set hidden
set cindent
set expandtab
set shiftwidth=2
set tabstop=2
set number
set title
set list
set listchars=tab:..,trail:_,eol:$,extends:>,precedes:<,nbsp:%
set cursorline
set showcmd
set cmdheight=1
set laststatus=2
set t_Co=256
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
"set clipboard=autoselect,unnamed
set incsearch
set nohlsearch
set ignorecase
set smartcase
set magic
set pastetoggle=<F4>
set ruler
set iskeyword+=-
set <BS>=
set ambiwidth=double
set virtualedit=all
set whichwrap=b,s,<,>,[,],
set autoread
set wildmenu
set display=lastline

set textwidth=0
if (&textwidth == 0)
  set colorcolumn=100
else
  set colorcolumn=+1
endif

set autochdir
set foldmethod=indent
"set spell
set spelllang=en,cjk
set autochdir
" 大きいファイル開くときにhlがdisableされるので
set redrawtime=5000 " msec

exe 'source' expand('<sfile>:p:h') . '/' . 'tabline.vim'

" Note: edit/view binary
" set binary

