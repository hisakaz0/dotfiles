
" dein ----------------------------------------
  if &compatible
    set nocompatible               " Be iMproved
  endif

  " Required:
  set runtimepath^=/Users/hisakazu/.vim/bundle/repos/github.com/Shougo/dein.vim

  " Required:
  call dein#begin('/Users/hisakazu/.vim/bundle')

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

" ColorSheme ---------------------------------------
  colorscheme inkpot
  syntax enable

" CursorHighlight
  function! MyCursorHighlight()
    highlight CursorLine ctermbg=235 guibg=DarkRed cterm=bold
  endfunction
  call MyCursorHighlight()
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre * call MyCursorHighlight()

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
  set ruler " show line and column
  set iskeyword+=-

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

" autocmd ------------------------------------------
  " autocmd BufEnter * if &filetype == '' | setlocal filetype=markdown | endif
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.coffee set ft=coffee
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.conf set ft=configuration
  " autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.erb set ft=html
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.{mkd,mk,markdown} set filetype=markdown
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.json set filetype=javascript
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.short set filetype=short

" Revise Indent(CorrectCode) -----------------------
  inoremap <C-K> <Esc>:call CorrectCode()<CR>a
  nnoremap <C-K> :call CorrectCode()<CR>
  function! CorrectCode()
    execute ":mkview"
    execute ":normal gg=G"
    execute ":loadview"
  endfunction

" Count Charactor ----------------------------------
  command! Count %s/./&/g

" " NeoComplete --------------------------------------
"   if (has('lua'))
"     "Note: This option must set it in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
"     " Disable AutoComplPop.
"     let g:acp_enableAtStartup = 0
"     " Use neocomplete.
"     let g:neocomplete#enable_at_startup = 1
"     " Use smartcase.
"     let g:neocomplete#enable_smart_case = 1
"     " Set minimum syntax keyword length.
"     let g:neocomplete#sources#syntax#min_keyword_length = 3
"     let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
" 
"     " Define dictionary.
"     let g:neocomplete#sources#dictionary#dictionaries = {
"           \ 'default' : '',
"           \ 'vimshell' : $HOME.'/.vimshell_hist',
"           \ 'scheme' : $HOME.'/.gosh_completions'
"           \ }
" 
"     " Define keyword.
"     if !exists('g:neocomplete#keyword_patterns')
"       let g:neocomplete#keyword_patterns = {}
"     endif
"     let g:neocomplete#keyword_patterns['default'] = '\h\w*'
" 
"     " Plugin key-mappings.
"     inoremap <expr><C-g>     neocomplete#undo_completion()
"     inoremap <expr><C-l>     neocomplete#complete_common_string()
" 
"     " Recommended key-mappings.
"     " <CR>: close popup and save indent.
"     inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"     function! s:my_cr_function()
"       " return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
"       " For no inserting <CR> key.
"       return pumvisible() ? "\<C-y>" : "\<CR>"
"     endfunction
"     " <TAB>: completion.
"     inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
"     inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
"     " <C-h>, <BS>: close popup and delete backword char.
"     inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
"     inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
"     " Close popup by <Space>.
"     "inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"
" 
"     " AutoComplPop like behavior.
"     "let g:neocomplete#enable_auto_select = 1
" 
"     " Shell like behavior(not recommended).
"     "set completeopt+=longest
"     "let g:neocomplete#enable_auto_select = 1
"     "let g:neocomplete#disable_auto_complete = 1
"     "inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"
" 
"     " Enable omni completion.
"     autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"     autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"     autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"     autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
"     autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
" 
"     " Enable heavy omni completion.
"     if !exists('g:neocomplete#sources#omni#input_patterns')
"       let g:neocomplete#sources#omni#input_patterns = {}
"     endif
"     "let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"     "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"     "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
" 
"     " For perlomni.vim setting.
"     " https://github.com/c9s/perlomni.vim
"     let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
"   endif

" Set os type
  let g:os_type = substitute(system('uname'), "\n", "", "g")

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

" Unite.vim & Vimfiler -----------------------------
  " Unite.vim
  let g:unite_enable_start_insert = 1
  let g:unite_source_history_yank_enable = 1
  nnoremap <silent> <Leader>ua :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
  " open buffers
  nnoremap <silent> <Leader>ub :<C-u>Unite<Space>buffer<CR>
  " open registers
  nnoremap <silent> <Leader>ur :<C-u>Unite<Space>register<CR>
  " open buffer history
  nnoremap <silent> <Leader>uh :<C-u>Unite<Space>neomru/file<CR>
  " open bookmark
  nnoremap <silent> <Leader>uf :<C-u>Unite<Space>bookmark<CR>
  autocmd FileType unite call s:unite_my_settings()
  function! s:unite_my_settings()
    nmap <buffer> <ESC> <Plug>(unite_exit)
    nnoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
    inoremap <silent><buffer><expr> f unite#smart_map('f', unite#do_action('vimfiler'))
  endfunction
  " Vimfiler
  let g:vimfiler_as_default_explorer = 1
  nnoremap <silent> <Leader>f :VimFiler<CR>

" Syntastic
  " let g:syntastic_javascript_checker = "jshint" "JavaScriptのSyntaxチェックはjshintで
  " let g:syntastic_check_on_open = 0 "ファイルオープン時にはチェックをしない
  " let g:syntastic_check_on_save = 0 "ファイル保存時にはチェックを実施

" VIM Table Mode
  let g:table_mode_corner_corner = "|"
  let g:table_mode_corner        = "|"

" Created Vim plugin
  source ~/tmp/vim/todo.vim

" Go lang
  let g:go_fmt_autosave = 0
  let g:go_play_open_browser = 0

" Autodirmak.vim
  let g:autodirmake#is_confirm = 0 " No confirmation

" ShortShort
  "  augroup shortshort
  "    autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.short set filetype=short
  "    " TODO: imap/inoremapで設定したDeleteCornerBrackets()が動かない
  "    autocmd Filetype short inoremap <BS> <C-R>=DeleteCornerBrackets(getline('.'))<CR>
  "    autocmd Filetype short inoremap ｢ ｢｣<left>
  "  augroup END
  "  function! DeleteCornerBrackets(line)
  "    echomsg a:line
  "    if a:line =~ '｢'
  "      if a:line !~ '｣'
  "        call setline('.', substitute(a:line, '｢', '', ''))
  "      endif
  "    endif
  "    if a:line =~ '｣'
  "      if a:line !~ '｢'
  "        call setline('.', substitute(a:line, '｣', '', ''))
  "      endif
  "    endif
  "    return ''
  "  endfunction

" Thor that ruby gem
  autocmd BufRead,BufEnter,BufNewFile,BufReadPre *.thor set ft=ruby

" Moving
  inoremap <C-E> <C-X><C-E>
  inoremap <C-Y> <C-X><C-Y>

" Common Lisp / Slimv
  aug lisp
    au!
    au Filetype listp setl cindent& lispwords=define
  aug END

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

" Dictionary
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

" Openrcnt
  nnoremap <Leader>rcnt :RecentList<CR>

" Markdown
  nnoremap <Leader>mkdn :set ft=markdown<CR>
