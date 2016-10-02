
" Comman variables ----------------------------
let g:os_type = substitute(system('uname'), "\n", "", "g")

" dein ----------------------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
if g:os_type == 'Darwin'
  set runtimepath^=/Users/hisakazu/.vim/bundle/repos/github.com/Shougo/dein.vim
  call dein#begin('/Users/hisakazu/.vim/bundle')
endif
if g:os_type == 'Linux'
  set runtimepath^=/home/hisakazu-fu/.vim/bundle/repos/github.com/Shougo/dein.vim
  call dein#begin('/home/hisakazu-fu/.vim/bundle')
endif

" Required:

call dein#add('dhruvasagar/vim-table-mode')
call dein#add('ciaranm/inkpot')
call dein#add('tomtom/tcomment_vim')
call dein#add('ap/vim-buftabline')
call dein#add('kchmck/vim-coffee-script')
call dein#add('glidenote/memolist.vim')
call dein#add('joker1007/vim-markdown-quote-syntax')
call dein#add('godlygeek/tabular')
call dein#add('kannokanno/previm')
call dein#add('rcmdnk/vim-markdown')
call dein#add('vim-scripts/AnsiEsc.vim')
call dein#add('fatih/vim-go')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('itchyny/lightline.vim')
call dein#add('hail2u/vim-css3-syntax')
call dein#add('scrooloose/syntastic')
call dein#add('vim-jp/vimdoc-ja')
call dein#add('Shougo/NeoComplete.vim')
" call dein#add('Valloric/YouCompleteMe')

" Let dein manage dein
" Required:
call dein#add('Shougo/dein.vim')

" Required:
call dein#end()

" Required:
filetype plugin indent on

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

" deoplete
let g:deoplete#enable_at_startup = 1

" ColorSheme ---------------------------------------
colorscheme inkpot
syntax enable

" CursorHighlight
function! MyCursorHighlight()
  highlight CursorLine ctermbg=235 guibg=DarkRed cterm=bold
endfunction
call MyCursorHighlight()

augroup my_highlight
  autocmd!
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre * call MyCursorHighlight()
augroup END

" Set Options --------------------------------------
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
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set clipboard+=autoselect
set clipboard+=unnamed
set incsearch
set nohlsearch
set ignorecase
set smartcase
set magic
set pastetoggle=<F4>
set ruler " show line and column
set iskeyword+=-
set <BS>=

au BufRead,BufEnter,BufNewFile * set formatoptions-=ro



" Fold Setting -------------------------------------
" set foldmethod=marker
set foldmethod=indent

" Common Map ---------------------------------------
let mapleader=','
nmap <F1> <Nop>
nnoremap ; :
vnoremap ; :
nnoremap <silent> <C-n> :bn<CR>
nnoremap <silent> <C-p> :bp<CR>
inoremap <C-s> <Esc>:w<CR>
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-s> <Esc>:w<CR>
nnoremap <C-q> <Esc>:q<CR>
inoremap <S-Tab> <Esc><<i

" autocmd ------------------------------------------
augroup my_filetype
  autocmd!
  " autocmd BufEnter * if &filetype == '' | setlocal filetype=markdown | endif
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.coffee set ft=coffee
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.conf set ft=configuration
  " autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.erb set ft=html
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.{mkd,mk,markdown} set filetype=markdown
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.json set filetype=javascript
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.short set filetype=short
augroup END

" Revise Indent(CorrectCode) -----------------------
inoremap <C-K> <Esc>:call CorrectCode()<CR>a
nnoremap <C-K> :call CorrectCode()<CR>
function! CorrectCode()
  execute ":mkview"
  execute ":normal gg=G"
  execute ":loadview"
endfunction


" Neocomplete --------------------------------------
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 0
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
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
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
augroup neocomp_omni
  autocmd!
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
augroup END

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
if g:os_type == "Darwin"
  let g:previm_open_cmd = 'open -a "/Applications/Google Chrome.app/"'
endif

" MemoList -----------------------------------------
let g:memolist_path = "~/tmp/MemoList"
if g:os_type == "Windows"
  let g:memolist_path = "/d/Users/hisakazu/tmp/MemoList"
endif
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>

" Syntastic
" let g:syntastic_javascript_checker = "jshint" "JavaScriptのSyntaxチェックはjshintで
let g:syntastic_check_on_open = 0 "ファイルオープン時にはチェックをしない
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }

" VIM Table Mode
let g:table_mode_corner_corner = "|"
let g:table_mode_corner        = "|"

" Go lang
let g:go_fmt_autosave = 0
let g:go_play_open_browser = 0

" Autodirmak.vim
let g:autodirmake#is_confirm = 0 " No confirmation

" Moving
" inoremap <C-E> <C-X><C-E>
" inoremap <C-Y> <C-X><C-Y>

" Jq / Json Parser ---------------------------------
command! Jq %!jq '.'

" Utilities
command! Date echo substitute(system('date'), "\n", "", "g")
command! -nargs=+ -complete=shellcmd Shell echo system(<f-args>)

" Help Documents
set helplang=ja,en
" If you want to read english  vim  documents,  then  you  type  :help  @en.

" Text Align
" type :help 25.2

" Mac Dictionary
let g:open_dictionary_window_cmd = 'new'
command! -nargs=1 Dict  call OpendictSearch(<f-args>)
nnoremap <Leader>dict :call OpendictSearchwordcursor()<CR>

function! OpendictSearchwordcursor()
  let s:line = getline('.')
  let s:wstart = getpos('.')[2] - 1
  let s:wend = s:wstart
  while(matchstr(s:line[s:wstart], "[A-Za-z]") != "")
    let s:wstart -= 1
  endwhile
  let s:wstart += 1
  while(matchstr(s:line[s:wend], "[A-Za-z]" ) != "")
    let s:wend += 1
  endwhile
  let s:wend -= 1
  let s:word =  s:line[s:wstart:s:wend]
  call OpendictSearch(s:word)
endfunction

function! OpendictSearch(word)
  let s:mean = system("dict " . a:word)
  if (matchstr(s:mean, "null") == "null" )
    echoerr "Error: No meaning in dictionary."
    return
  endif
  execute g:open_dictionary_window_cmd .
        \ " DICT:" . a:word . " | put =s:mean"
  execute "1,2delete"
  setlocal buftype=nofile
  setlocal bufhidden=delete
  setlocal noswapfile
endfunction

" Openrcnt(plugin)
nnoremap <Leader>rcnt :RecentList<CR>

" Markdown
nnoremap <Leader>mkdn :set ft=markdown<CR>

nnoremap <Leader>hl :call InsertHeaderLine()<CR>

" Insert header line (for h1)
function! InsertHeaderLine()
  let s:virtcol = virtcol('$') - 1
  let s:line = line('.')
  let s:i = 0
  let s:dash = ""
  while s:i < s:virtcol
    let s:dash .= "="
    let s:i += 1
  endwhile
  echo s:dash
  execute s:line . "put =s:dash"
endfunction

augroup c_lang " not clang
  autocmd!
  autocmd BufEnter,BufRead,BufNewFile *.c call CLangSetting()
augroup END

function! CLangSetting()
  if Chomp(system("ls -1 Makefile")) == "Makefile"
    nnoremap <Leader>make :make<CR>
    nnoremap <Leader>run :make run<CR>
    nnoremap <Leader>arun :make run ARGS="
  else
    nnoremap <Leader>make :!gcc %<CR>
    nnoremap <Leader>run :!./a.out<CR>
    nnoremap <Leader>arun :!./a.out
  endif
endfunction

function! Chomp(str)
  return substitute(a:str, '\n$', '', "")
endfunction

" Tabpage
if g:os_type == 'Linux'
  set <k0>=n " alt + n
  set <k1>=p " alt + p
endif
nnoremap <k0> :tabn<CR>
nnoremap <k1> :tabp<CR>

" Verilog
augroup my_verilog
  autocmd!
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.vh set filetype=verilog
augroup END

" Quickfix
nnoremap <silent> <Leader>cn :cn<CR>
nnoremap <silent> <Leader>cp :cp<CR>
nnoremap <silent> <Leader>cc :cc<CR>
nnoremap <silent> <Leader>tab :tab split<CR>

" Highlight search toggle
nnoremap <silent> <Leader>hls :set invhlsearch<CR>

" Maplist
nnoremap <silent> <Leader>nmap :nmap<CR>
