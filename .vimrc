
" %% VIM SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" runtimepath{{{
if isdirectory($HOME. "/.vim")
  execute "set runtimepath^=" .$HOME. "/.vim"
endif
if isdirectory($HOME. "/.usr/local/share/vim/vim80")
      \ && (match(v:version, "80[0-9]") >= 0)
  execute "set runtimepath^=" .$HOME. "/.usr/local/share/vim/vim80"
endif
"}}}

" common options " ======================================================"{{{2
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
if has('xterm_clipboard')
  set clipboard+=autoselect
  set clipboard+=unnamed
endif
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
set whichwrap=b,s,<,>,[,],
set autoread
set colorcolumn=+1
set wildmenu
set wildmode=list:longest
set display=lastline
set textwidth=78
" If you edit or read binary file,
" you should set following option, 'set binary'.
" set binary

" If you view diff of some files,
" you should open with 'vim -d <file> ...', or
" set option 'set scrollbind', 'set cursorbind'
" set scrollbind
" set cursorbind

au BufRead,BufEnter,BufNewFile * set formatoptions-=ro

" shell debug
autocmd FileType sh :noremap <F6> :.w !$SHELL<Return>
"}}}
" fold " ================================================================"{{{2
" NOTE: vim option 'foldmethod' is automatically set by function,
" 'SetFoldMethod'. This function are called at the event 'BufEnter'.
autocmd BufEnter * call SetFoldMethod()
function! SetFoldMethod()
  let l:pos = getpos('.')
  if (search(split(&foldmarker, ',')[0]))
    set foldmethod=marker
  else
    set foldmethod=indent
  endif
  call setpos('.', l:pos)
endfunction
set foldtext=FoldCCtext()
set foldcolumn=5
set fillchars=vert:\|
let g:foldCCtext_tail = 'printf("   %s[%4d lines  Lv%-2d]%s",
      \ v:folddashes, v:foldend-v:foldstart+1, v:foldlevel, v:folddashes)'
"}}}
" common map " =========================================================="{{{2
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
    let s:space = " "
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
" toggle highlight search " ============================================ "{{{2
nnoremap <silent> <Leader>hls :set invhlsearch<CR>
" nnoremap <silent> <F5>        :set invhlsearch<CR>
"}}}
" abbreviatio " ========================================================="{{{2
iabbrev lenght length
iabbrev assing assign
iabbrev bse base
"}}}
" tabpage " ============================================================="{{{2
if has('unix')
  set <k0>=n " alt + n
  set <k1>=p " alt + p
endif
nnoremap <k0> :tabn<CR>
nnoremap <k1> :tabp<CR>
nnoremap <Leader>tabn :tabn<CR>
nnoremap <Leader>tabp :tabp<CR>
nnoremap <Leader>tabs :tab split<CR>

set tabline=%!MyTabLine()

function! MyTabLine ()
  let s = ''
  for i in range(tabpagenr('$'))
    if i+1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    let s .= '%' . (i+1) . 'T'
    let s .= ' %{MyTabLabel(' . (i+1) . ')} '
  endfor

  let s .= '%#TabLineFill#%T'
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#999Xclose'
  endif

  return s
endfunction

function! MyTabLabel (n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1])
endfunction

" quickfix " ============================================================"{{{2
nnoremap <silent> <Leader>cn :cn<CR>
nnoremap <silent> <Leader>cp :cp<CR>
nnoremap <silent> <Leader>cc :cc<CR>
"}}}
" help documents " ======================================================="{{{
set helplang=ja
" If you want to read english  vim  documents,  then  you  type  :help  @en.
" 2017/01/10: version of vim japanese documents is 7.4
"}}}
" text align " ==========================================================="{{{
" type :help 25.2
" packadd! justify
"}}}
"}}}
" %% UTILITY COMMANDS AND FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" date " ================================================================"{{{2
command! Date call Date()
function! Date()
   return substitute(system('date'), "\n", "", "g")
endfunction
command! -nargs=+ -complete=shellcmd Shell echo system(<f-args>)
"}}}
" Revise Indent(CorrectCode) " ==========================================="{{{
"inoremap <C-K> <Esc>:call CorrectCode()<CR>a
"nnoremap <C-K> :call CorrectCode()<CR>
"function! CorrectCode()
"  execute ":mkview"
"  execute ":normal gg=G"
"  execute ":loadview"
"endfunction
"}}}
" Insert header line (for h1) " =========================================="{{{
nnoremap <silent> <Leader>hl :put =InsertHeaderLine()<CR>

function! InsertHeaderLine(...)
  " input args:
  "   1. ch <STRING>
  if (&textwidth) | let l:leng = &textwidth
  else            | let l:leng = getcurpos()[2] | endif
  if (a:0) | let l:ch = type(a:1) == type('') ? a:1 : string(a:1)
  else     | let l:ch = '=' | endif
  let l:header_line = ConcatString(l:ch, l:leng)
  return l:header_line
endfunction
"}}}
" Chomp  " =============================================================="{{{2
function! Chomp(str)
  return substitute(a:str, '\n$', '', "")
endfunction
"}}}
" Count chars" =========================================================="{{{2
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
" %% PLUGINS SETTIGNS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" " dein " =============================================================="{{{2
"
" debugging information
" - plugins list: g:dein#_plugins
"

 if &compatible
   set nocompatible " Be iMproved
 endif

 let s:bundle_path = $HOME ."/.vim/bundle"
 let s:dein_path = s:bundle_path ."/repos/github.com/Shougo/dein.vim"
 if ! isdirectory(s:dein_path)
   let s:dein_installer_url =
         \ "https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh"
   let s:dein_installer_path = $HOME ."/.dein-installer.sh"
   echo "Installing dein.vim"
   call system(printf("curl %s > %s && sh %s %s",
         \ s:dein_installer_url, s:dein_installer_path,
         \ s:dein_installer_path, s:bundle_path))
 endif

 execute "set runtimepath^=" . s:dein_path
 if dein#load_state(s:bundle_path)
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
   call dein#add('itchyny/dictionary.vim')
   " NOTE: Too heavy to insatll the plugin
   " call dein#add('apple/swift',
   "       \ {'rtp': 'utils/vim' })
   call dein#add('LeafCage/foldCC.vim')
   call dein#add('Shougo/vimproc.vim',
         \ {'build' : 'make' })
   call dein#add('cespare/vim-toml')
   call dein#add('pinkienort/openrcnt.vim')
   call dein#add('pinkienort/shimapan.vim')
   call dein#add('thinca/vim-themis')
   call dein#add('fuenor/JpFormat.vim')
   " reStructured Text
   " call dein#add('Rykka/riv.vim')
   call dein#add('thinca/vim-quickrun')

   " Completion plugins
   if has('lua')
     call dein#add('Shougo/NeoComplete.vim',
           \ {'lazy': 1, 'on_i': 1 })
     call dein#add('Shougo/neoinclude.vim',
           \ {'on_source': ['NeoComplete.vim'] })
     call dein#add('Shougo/context_filetype.vim',
           \ {'on_source': ['NeoComplete.vim'] })
   endif
   call dein#add('justmao945/vim-clang',
         \ {'on_ft': ['c', 'cpp'] })


   " Python plugins
   call dein#add('davidhalter/jedi-vim',
         \ {'on_ft': 'python' })
   call dein#add('lambdalisue/vim-pyenv',
         \ {'depends': ['jedi-vim'],
         \  'on_source': ['jedi-vim'],
         \  'lazy': 1,
         \  'on_ft': ['python', 'python3'] })

   " Required:
   call dein#add('Shougo/dein.vim')

   " install all of plugins with only depth-1
   call dein#config(keys(dein#get()), { 'type__depth': 1 })
   " Let dein manage dein

   " Required:
   call dein#end()
   call dein#save_state()
 endif


 " Required:
 filetype plugin indent on

 " If you want to install not installed plugins on startup.
 if dein#check_install()
   call dein#install()
 endif

 " NOTE: dein_plugins_list_path is
 " $HOME . "/work/github/pinkienort/dotfiles/.vim/dein-plugins-list.bkup.toml
 " you can get contest of plugins list using following command.
 " dein#plugins2toml(values(dein#get()))

" "}}}
" Neocomplete " ========================================================="{{{2
if has('lua')
  " Disable AutoComplPop. 0: disable | 1: enable
  let g:acp_enableAtStartup = 0
  " deoplete
   let g:deoplete#enable_at_startup = 0

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
  inoremap <expr><C-g> neocomplete#undo_completion()
  inoremap <expr><C-l> neocomplete#complete_common_string()

  " Recommended key-mappings.
  " <CR>: close popup and save indent.
  inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
  function! s:my_cr_function()
    " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? "\<C-y>" : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>   pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
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
  " augroup neocomp_omni
  "   autocmd!
  "   autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  "   autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
  "   autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  "   autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
  "   autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
  " augroup END

  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  if !exists('g:neocomplete#force_omni_input_patterns')
    let g:neocomplete#force_omni_input_patterns = {}
  endif

  " Use vim-clang instead of neocomplete
  " let g:neocomplete#force_overwrite_completefunc = 1
  " let g:neocomplete#force_omni_input_patterns.c =
  "       \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'
  " let g:neocomplete#force_omni_input_patterns.cpp =
  "       \ '[^.[:digit:] *\t]\%(\.\|->\)\w*\|\h\w*::\w*'

  "let g:neocomplete#sources#omni#input_patterns.php =
  "      \ '[^. \t]->\h\w*\|\h\w*::'

  " For perlomni.vim setting.
  " https://github.com/c9s/perlomni.vim
  " let g:neocomplete#sources#omni#input_patterns.perl =
  "       \ '\h\w*->\h\w*\|\h\w*::'

  " For smart TAB completion.
  "inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
  "        \ <SID>check_back_space() ? "\<TAB>" :
  "        \ neocomplete#start_manual_complete()
  "  function! s:check_back_space() "{{{
  "    let col = col('.') - 1
  "    return !col || getline('.')[col - 1]  =~ '\s'
  "  endfunction"}}}
endif
"}}}
" Previm " =============================================================="{{{2
if has('mac')
  let g:previm_open_cmd = 'open -a "/Applications/Google Chrome.app/"'
endif
"}}}
" MemoList " ============================================================"{{{2
let g:memolist_path = $HOME ."/tmp/MemoList"
if has('win32') || has('win64')
  let g:memolist_path = "/d/Users/hisakazu/tmp/MemoList"
endif
nnoremap <Leader>mn :MemoNew<CR>
nnoremap <Leader>ml :MemoList<CR>
nnoremap <Leader>mg :MemoGrep<CR>
"}}}

" Syntastic " ==========================================================="{{{2
"JavaScriptのSyntaxチェックはjshintで
" let g:syntastic_javascript_checker = "jshint"
let g:syntastic_check_on_open = 0 "ファイルオープン時にはチェックをしない
let g:syntastic_check_on_save = 0 "ファイル保存時にはチェックを実施
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
  \ "mode": "passive", "active_filetypes": [], "passive_filetypes": [] }
" if you want to active save-on-check, change "passive" to "active"
"}}}
" VIM Table Mode " ======================================================"{{{2
"let g:table_mode_corner_corner = "|"
"let g:table_mode_corner        = "|"
augroup my_vim_table_mode
  autocmd! Filetype rst call MyVimTableModeSettings()
augroup END

function! MyVimTableModeSettings()
  let g:table_mode_corner_corner = "+"
  let g:table_mode_corner        = "+"
endfunction
"}}}
" Go lang " ============================================================="{{{2
let g:go_fmt_autosave = 0
let g:go_play_open_browser = 0
"}}}
" Autodirmak.vim " ======================================================"{{{2
let g:autodirmake#is_confirm = 0 " No confirmation
"}}}
" Openrcnt(plugin) " ===================================================="{{{2
nnoremap <Leader>rcnt :RecentList<CR>
"}}}
" Dictionary =============================================================={{{
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
" Make directory automatically "{{{
" ref: http://tyru.hatenablog.com/entry/20140518/vimhacks_mkdir_hack_without_vimrc
augroup vimrc-auto-mkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'))
  function! s:auto_mkdir(dir)
    if !isdirectory(a:dir)
      call mkdir(iconv(a:dir, &encoding, &termencoding), 'p')
    endif
  endfunction
augroup END
"}}}
" vim-trailing-whitespace {{{
let g:extra_whitespace_ignored_filetypes = [ 'shimapan' ]
"}}}
" shimapan.vim {{{
let g:shimapan_first_color  = "ctermfg=253 ctermbg=0"
let g:shimapan_second_color = "ctermfg=15  ctermbg=234"
"}}}
" bufferlist.vim "{{{
map <silent> <C-B> :call BufferList()<CR>
command! BufferList :call BufferList()
"}}}
"}}}
" %% DOMAIN-SPECIFIC SETTINGS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"{{{1
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
" %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

" Gnuplot
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.plt set ft=sh

" ============================================================================
" Coffee Script
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.coffee set ft=coffee

" ============================================================================
" Common autocmd
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.conf set ft=configuration

" ============================================================================
" Javascript
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.json set filetype=javascript

" ============================================================================
" ShortShort
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.{ss,shortshort}
      \set filetype=shortshort

" ===========================================================================
" Markdown
autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.{mkd,mk,markdown}
      \set filetype=markdown
nnoremap <Leader>mkdn :set ft=markdown<CR>

" ============================================================================
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
    set makeprg=gcc\ %
    nnoremap <Leader>make :!gcc %<CR>
    nnoremap <Leader>run :!./a.out<CR>
    nnoremap <Leader>arun :!./a.out
  endif
endfunction

" vim-clang
let g:clang_c_completeopt = 'longest,menu,preview'

" ============================================================================
" Verilog
augroup my_verilog
  autocmd!
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.vh set filetype=verilog
augroup END

" ============================================================================
" Jq / Json Parser
command! Jq %!jq '.'
"
" experimental
" set runtimepath^=~/tmp/vim/shortshort

" ============================================================================
" Python / jedi-vim
augroup my_python
  autocmd!
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.py call MyPythonSetting()
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.ipy call MyPythonSetting()
augroup END

function! MyPythonSetting()
  set makeprg=python\ \%
  set shiftwidth=4
  set tabstop=4
endfunction

""" jedi-vim setting
" mapping to start completion
let g:jedi#completions_command = "<C-N>"
" mapping to open document
let g:jedi#documentation_command = '<leader>k'
" use version 3 of python
if has('python3')
  let g:jedi#force_py_version = 3
endif
" after showing preview window of doc, do not close
" 1: auto close / 0: dont close
let g:jedi#auto_close_doc = 0
"}}}
" ========================================================================="{{{
" Jpformat
set formatexpr=jpfmt#formatexpr()
"}}}
" ============================================================================
" latex / tex
augroup my_latex
  autocmd! BufRead,BufEnter,BufReadPre *.tex call MyLatexSetting()
augroup END

function! MyLatexSetting()
  set textwidth=78
endfunction

" colorsheme & cursorhighlight " =========================================={{{
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

" ============================================================================
" JpFormat
" set formatexpr=jpvim#formatexpr()
"}}}

