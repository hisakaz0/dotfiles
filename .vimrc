
" %% VIM SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" runtimepath
if isdirectory($VIM . '/vim80')
  set runtimepath^=$VIM/vim80
endif

" common options " ============================================================"{{{2
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
set listchars=tab:..,trail:_,eol:$,extends:>,precedes:<,nbsp:%
set cursorline
set showcmd
set cmdheight=1
set laststatus=2
set t_Co=256
set encoding=utf-8
set fileencodings=iso-2022-jp,cp932,sjis,euc-jp,utf-8
set clipboard+=autoselect
set clipboard+=unnamed
set incsearch
set nohlsearch
set ignorecase
set smartcase
set magic
set pastetoggle=<F4>
" show line and column
set ruler
set iskeyword+=-
set <BS>=
" for multibyte character
set ambiwidth=double
set virtualedit=all
au BufRead,BufEnter,BufNewFile * set formatoptions-=ro
"}}}
" fold " ============================================================"{{{2
" NOTE: vim option 'foldmethod' is automatically set by function,
" 'SetFoldMethod'. This function are called at the event 'BufEnter'.
autocmd BufEnter * call SetFoldMethod()
function! SetFoldMethod()
  if (search(split(&foldmarker, ',')[0]))
    set foldmethod=marker
  else
    set foldmethod=indent
  endif
endfunction
set foldtext=FoldCCtext()
set foldcolumn=5
set fillchars=vert:\|
let g:foldCCtext_tail = 'printf("   %s[%4d lines  Lv%-2d]%s",
      \ v:folddashes, v:foldend-v:foldstart+1, v:foldlevel, v:folddashes)'
"}}}
" common map " ============================================================"{{{2
let mapleader=','
" alias of escape
inoremap <C-j> <ESC>
nnoremap <C-j> <ESC>
nnoremap <F1> <Nop>
inoremap <F1> <Nop>
nnoremap ; :
vnoremap ; :
inoremap <C-Y> <C-X><C-Y>
inoremap <C-E> <C-X><C-E>
nnoremap <silent> <C-n> :bn<CR>
nnoremap <silent> <C-p> :bp<CR>
inoremap <C-s> <Esc>:w<CR>
"inoremap <C-q> <Esc>:q<CR>
nnoremap <C-s> <Esc>:w<CR>
"nnoremap <C-q> <Esc>:q<CR>
" search in magic mode
nnoremap / /\v
nnoremap ? ?\v


" moving
inoremap <C-E> <C-X><C-E>
inoremap <C-Y> <C-X><C-Y>

" shift tab
inoremap <S-Tab> <C-R>=RightShiftOneTab()<CR><BS>

function! RightShiftOneTab()
  let s:pos  = getpos('.')
  let s:line = getline('.')
  let s:i = 0
  let s:space = ' '
  let s:volume = &tabstop
  if (!(&expandtab))
    let s:space = "	"
    let s:volume = 1
  endif
  while (s:i < s:volume)
    if (s:line[0] == s:space)
      let s:line = s:line[1:]
    else
      break
    endif
    let s:i = s:i + 1
  endwhile
  let s:pos[2] = s:pos[2] - s:i " col position
  call setline('.', s:line)
  call setpos('.', s:pos)
endfunction
"}}}
" toggle highlight search " ============================================================ "{{{2
nnoremap <silent> <Leader>hls :set invhlsearch<CR>
" nnoremap <silent> <F5>        :set invhlsearch<CR>
"}}}
" abbreviatio " ============================================================"{{{2
iabbrev lenght length
iabbrev assing assign
iabbrev bse base
"}}}
" tabpage " ============================================================"{{{2
if has('unix')
  set <k0>=n " alt + n
  set <k1>=p " alt + p
endif
nnoremap <k0> :tabn<CR>
nnoremap <k1> :tabp<CR>
" quickfix " ============================================================"{{{2
nnoremap <silent> <Leader>cn :cn<CR>
nnoremap <silent> <Leader>cp :cp<CR>
nnoremap <silent> <Leader>cc :cc<CR>
nnoremap <silent> <Leader>tab :tab split<CR>
"}}}
" help documents " ============================================================"{{{
set helplang=ja
" If you want to read english  vim  documents,  then  you  type  :help  @en.
" 2017/01/10: version of vim japanese documents is 7.4
"}}}
" text align " ============================================================"{{{
" type :help 25.2
"}}}
"}}}
" %% UTILITY COMMANDS AND FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" date " ============================================================"{{{2
command! Date echo substitute(system('date'), "\n", "", "g")
command! -nargs=+ -complete=shellcmd Shell echo system(<f-args>)
"}}}
" Revise Indent(CorrectCode) " ============================================================"{{{
"inoremap <C-K> <Esc>:call CorrectCode()<CR>a
"nnoremap <C-K> :call CorrectCode()<CR>
"function! CorrectCode()
"  execute ":mkview"
"  execute ":normal gg=G"
"  execute ":loadview"
"endfunction
"}}}
" Insert header line (for h1) " ============================================================"{{{
nnoremap <silent> <Leader>hl :call InsertHeaderLine()<CR>

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
"}}}
" Chomp  " ============================================================"{{{2
function! Chomp(str)
  return substitute(a:str, '\n$', '', "")
endfunction
"}}}
" Count chars" ============================================================"{{{2 
" help g_CTRL-G
"}}}
" ClearUndoHistory{{{
if has('dialog_con')
  function! ClearUndoHistoryFunc()
    let l:choice = confirm('Really clear undo-history?', "&Yes\n&No", 2)
    if l:choice != 1
      return 1
    endif

    let l:old_undolevels = &undolevels
    set undolevels=-1
    exe "normal a \<BS>\<Esc>"
    let &undolevels = old_undolevels
    unlet l:old_undolevels
  endfunction

  command! ClearUndoHistory :call ClearUndoHistoryFunc()
endif
"}}}
"}}}
" %% PLUGINS SETTIGNS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" " dein " ============================================================"{{{2
"
" debugging information
" - plugins list: g:dein#_plugins
"
 if &compatible
   set nocompatible " Be iMproved
 endif
 
 set runtimepath^=$HOME/.vim/bundle/repos/github.com/Shougo/dein.vim
 if dein#load_state('$HOME/.vim/bundle')
   " Required:
   call dein#begin('$HOME/.vim/bundle')
 
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
   call dein#add('itchyny/dictionary.vim')
   call dein#add('Shougo/vimproc.vim', {'build' : 'make'})
   call dein#add('apple/swift',
     \ {
     \ 'rtp': 'utils/vim',
     \ 'type__depth': 1,
     \ })
   " call dein#add('Valloric/YouCompleteMe')
   call dein#add('LeafCage/foldCC.vim')
 
   " Let dein manage dein
   " Required:
   call dein#add('Shougo/dein.vim')
 
   " Required:
   call dein#end()
   call dein#save_state()
 endif
 
 
 " Required:
 filetype plugin indent on
 
 " If you want to install not installed plugins on startup.
 "if dein#check_install()
 "  call dein#install()
 "endif
 
 " deoplete
 " let g:deoplete#enable_at_startup = 1
" "}}}
" Neocomplete " ============================================================"{{{2
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
" inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
" inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
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
"}}}
" Previm " ============================================================"{{{2
if has('mac')
  let g:previm_open_cmd = 'open -a "/Applications/Google Chrome.app/"'
endif
"}}}
" MemoList " ============================================================"{{{2
let g:memolist_path = "~/tmp/MemoList"
if has('win32') || has('win64')
  let g:memolist_path = "/d/Users/hisakazu/tmp/MemoList"
endif
nnoremap <Leader>mn  :MemoNew<CR>
nnoremap <Leader>ml  :MemoList<CR>
nnoremap <Leader>mg  :MemoGrep<CR>
"}}}
" Syntastic " ============================================================"{{{2
" let g:syntastic_javascript_checker = "jshint" "JavaScriptのSyntaxチェックはjshintで
let g:syntastic_check_on_open = 0 "ファイルオープン時にはチェックをしない
let g:syntastic_check_on_save = 0 "ファイル保存時にはチェックを実施
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
  \ "mode": "passive", "active_filetypes": [], "passive_filetypes": [] }
" if you want to active save-on-check, change "passive" to "active"
"}}}
" VIM Table Mode " ============================================================"{{{2
let g:table_mode_corner_corner = "|"
let g:table_mode_corner        = "|"
"}}}
" Go lang " ============================================================"{{{2
let g:go_fmt_autosave = 0
let g:go_play_open_browser = 0
"}}}
" Autodirmak.vim " ============================================================"{{{2
let g:autodirmake#is_confirm = 0 " No confirmation
"}}}
" Openrcnt(plugin) " ============================================================"{{{2
nnoremap <Leader>rcnt :RecentList<CR>
"}}}
" Dictionary ========================================{{{
" buftype=nofile
" buflisted=nobuflisted
" bufhidden=hide
autocmd Filetype dictionary call MyDictionarySetting()
autocmd BufLeave,WinLeave * call ReloadMyMapping()

function! MyDictionarySetting()
  let l:imap_ctrl_s = maparg('<C-S>', 'i')
  if (l:imap_ctrl_s != '')
    iunmap <C-S>
  endif
  inoremap <silent> <C-S> <ESC>S
endfunction

function! ReloadMyMapping()
  iunmap <C-S>
  inoremap <C-s> <Esc>:w<CR>
endfunction


function! ConcatString(str, num)
  " input args:
  "   str <STRING>: str be concatenated
  "   num <INT>: how many concat 'str'
  " return val:
  "   <STRING>: concatenated string
  if (type(a:num) != type(0))  | return | endif
  if (type(a:str) != type("")) | return | endif
  if (a:num > &maxfuncdepth)
    let l:num = &maxfuncdepth - 2
  else
    let l:num = a:num
  endif
  return ConcatStringBody(a:str, l:num)
endfunction

function! ConcatStringBody(str, num)
  if (0 < a:num)
    return a:str . ConcatStringBody(a:str, (a:num-1))
  else
    return ''
  endif
endfunction
"}}}
"}}}
" %% DOMAIN-SPECIFIC SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" Gnuplot
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.plt set ft=sh

" ============================================================
" Coffee Script
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.coffee set ft=coffee

" ============================================================
" Common autocmd
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.conf set ft=configuration

" ============================================================
" Javascript
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.json set filetype=javascript

" ============================================================
" ShortShort
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.{ss,shortshort} set filetype=shortshort

" ============================================================
" Markdown
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.{mkd,mk,markdown} set filetype=markdown
nnoremap <Leader>mkdn :set ft=markdown<CR>

" ============================================================
" C
augroup c_lang " not meaned clang compiler
  autocmd!
  autocmd BufEnter,BufRead,BufNewFile *.{c,h} call CLangSetting()
augroup END

function! CLangSetting()
  if findfile("Makefile") == "Makefile"
    nnoremap <Leader>make :make<CR>
    nnoremap <Leader>run :make run<CR>
    nnoremap <F5> :make && make run<CR>
  else
    nnoremap <Leader>make :!gcc %<CR>
    nnoremap <Leader>run :!./a.out<CR>
    nnoremap <Leader>arun :!./a.out
  endif
endfunction

" ============================================================
" Verilog
augroup my_verilog
  autocmd!
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.vh set filetype=verilog
augroup END

" ============================================================
" Jq / Json Parser
command! Jq %!jq '.'
"
" experimental
" set runtimepath^=~/tmp/vim/shortshort

" ============================================================
" Python
augroup my_python
  autocmd!
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.py call MyPythonSetting()
augroup END

function! MyPythonSetting()
  set makeprg=python\ \%
  set shiftwidth=4
  set tabstop=4
endfunction
"}}}

" colorsheme & cursorhighlight " ==============================================={{{
" NOTE: DO NOT CHANGE ORDER of COMMANDS.
"       'dein.vim' ---> 'colorscheme' ---> 'highlight'
" colorsheme 'inkpot' is get from github.com, and this vim file is
" download by 'dein.vim' plugin. 'inkpot' shouled be loaded after 'dein.vim'.
"
" And, curorhighlight setting of 'inkpot' is not good. I don't like it.
" After inkpot settings, my cursorhighlight setting is loaded to overwrite.
colorscheme inkpot
syntax enable
function! MyCursorHighlight()
  highlight CursorLine ctermbg=235 guibg=DarkRed cterm=bold
endfunction
call MyCursorHighlight()

augroup my_highlight
  autocmd!
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre * call MyCursorHighlight()
augroup END
"}}}
