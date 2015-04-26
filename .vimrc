"#########
""  Arrow
""##########
" inoremap OA <Up>
" inoremap OB <Down>
" inoremap OC <Right>
" inoremap OD <Left>
"set timeoutlen=10
"set ttimeoutlen=15
""#############
""  Neobundle
""#############
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#begin(expand('~/.vim/bundle'))
call neobundle#end()
" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'
" vim plugins
NeoBundle 'basyura/jslint.vim'
NeoBundle 'basyura/bitly.vim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/TweetVim'
NeoBundle "godlygeek/tabular"
NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'jcf/vim-latex'
NeoBundle 'kovisoft/slimv'
NeoBundle 'marijnh/tern_for_vim',{
      \ 'build': {
      \ 'other': 'npm install'
      \}}
NeoBundle 'mattn/webapi-vim'
NeoBundle 'mattn/favstar-vim'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimshell.vim'
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'tools\\update-dll-mingw',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'linux' : 'make',
      \     'unix' : 'make',
      \    },
      \ }
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'tpope/vim-pathogen'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'wookiehangover/jshint.vim'
NeoBundle "tyru/caw.vim.git"
NeoBundle "groenewege/vim-less"
" add plugins
NeoBundleCheck
""############
""  Airline
""############
" Q&A Pages
" https://github.com/bling/vim-airline/wiki/FAQ
NeoBundle 'bling/vim-airline'
let g:airline_powerline_fonts = 1
let g:airline_section_a = airline#section#create(['mode','','branch'])
" denote buffers on the top bar
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_left_sep = '⮀ '
let g:airline_right_sep = ' ⮂'
let g:airline_left_alt_sep = ' ⮁ '
let g:airline_right_alt_sep = ' ⮃ '
let g:airline_symbols.linenr = '⭡'
let g:airline_symbols.branch = '⎇ '
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.whitespace = 'Ξ'
let g:airline_symbols.space = "\ua0"
let g:airline_symbols.readonly = '⭤'

""#############
""  Behavior
""#############
set showmatch
set mouse=a
set nf=alpha
set backspace=indent,eol,start
"set spell
""###########
""  Indent
""###########
set cindent
set expandtab
set shiftwidth=2
set tabstop=2
""###############
""  Completion
""###############
" NeoBundle 'MetalPhaeton/easybracket-vim'
NeoBundle 'Townk/vim-autoclose'
set wildmenu
set wildmode=longest,list
" inoremap {<Enter> {}<Left><CR><ESC><S-o>
" inoremap [<Enter> []<Left><CR><ESC><S-o>
" inoremap (<Enter> ()<Left><CR><ESC><S-o>
""################
""  IndentGuide
""################
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_guide_size=1
" custom color setting
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=17
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=143
" インデントハイライトのトグルスイッチ
nnoremap <silent> <F3> :IndentGuidesToggle<CR>
""###############
""  Appearance
""###############
set number
set title
set list
set listchars=tab:..,trail:_,eol:§,extends:>,precedes:<,nbsp:%
set cursorline
" set cursorcolumn
set showcmd
set cmdheight=1
set laststatus=2
" set statusline=%F%m%r%h%w
" set statusline+=%=
" set statusline+=[TYPE=%Y]/
" set statusline+=[FORMAT=%{&ff}]/
" set statusline+=[ENC=%{&fileencoding}]/
" set statusline+=[LOW=%l/%L]/
" set statusline+=[COLUM=%c/%{col('$')-1}]
""################
""  ColorScheme
""################
set t_Co=256
NeoBundle 'ciaranm/inkpot'
NeoBundle 'w0ng/vim-hybrid'
NeoBundle 'chriskempson/base16-vim'
" set colorscheme
" colorscheme peachpuff
" colorscheme hybrid
colorscheme inkpot
" colorscheme base16-default
" autocmd BufWrite  * :hi CursorLine ctermbg=235 guibg=DarkRed cterm=bold
autocmd BufEnter * :hi CursorLine ctermbg=235 guibg=DarkRed cterm=bold
""#########
""  Fold
""#########
set foldmethod=indent
" set foldlevel=2
" set foldcolumn=3
""###########
""  Encode
""###########
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
""###########
""  Backup
""###########
set backup "backupを有効化
set backupdir=~/.vim/backup/ "backupfileを保存するフォルダ
""##############
""  Clipboard
""##############
set clipboard+=autoselect
set clipboard+=unnamed
""###########
""  Search
""###########
set incsearch
" set hlsearch
noremap <silent> <F2> :set hlsearch! hlsearch?<CR>
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz
""###########
""  Buffer
""###########
nnoremap <silent> <C-n> :bn<CR>
nnoremap <silent> <C-p> :bp<CR>
" NeoBundle 'bling/vim-bufferline'
" let g:bufferline_show_bufnr = 0
" let g:bufferline_active_buffer_left = '-> '
" let g:bufferline_active_buffer_right = ''
" let g:bufferline_echo = 0
" autocmd VimEnter *
" \ let &statusline='%{bufferline#refresh_status()}'
" \ .bufferline#get_status_string()
" let g:bufferline_active_highlight = 'Tag'
"###########
""  Window
""###########
nnoremap <silent> <S-Left>  :5wincmd <<CR>
nnoremap <silent> <S-Right> :5wincmd ><CR>
nnoremap <silent> <S-Up>    :5wincmd -<CR>
nnoremap <silent> <S-Down>  :5wincmd +<CR>
"########################
""  Windows like keymap
"########################
" Save and back to Insert mode
" inoremap <C-s> <Esc>:w<CR>a
" Save and enter Normal mode
inoremap <C-s> <Esc>:w<CR>
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-s> <Esc>:w<CR>
nnoremap <C-q> <Esc>:q<CR>
""##########
""  Aided
""##########
" <F1>のtypoをなくす
nmap <F1> <Nop>
" mapleader
let mapleader=','
" shift押すのがめんどくさい
nnoremap ; :
vnoremap ; :
" トグルスイッチ
set pastetoggle=<F4>
" convert markdown to html
command! Mth :!mth %
" 行末の空白を削除
NeoBundle 'bronson/vim-trailing-whitespace'
" 整形ツール
"NeoBundle 'Align'
""################
""  CorrectCode
""################
" inoremap <C-k> <Esc>:call CorrectCode()<CR>a
" nnoremap <C-k> :call CorrectCode()<CR>
inoremap  <Esc>:call CorrectCode()<CR>a
nnoremap  :call CorrectCode()<CR>
function! CorrectCode()
  execute ":mkview"
  execute ":normal gg=G"
  execute ":loadview"
endfunction
""############
""  Zenkaku
""############
" 全角スペースを可視化
highlight ZenkakuSpace cterm=underline ctermbg=red guibg=#666666
au BufWinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
au WinEnter * let w:m3 = matchadd("ZenkakuSpace", '　')
" 全角を半角に
function! HZ()
  let zenkakuList = ['１','２','３','４','５','６','７','８','９']
  let numLine =
  for s:key in range(0,9)
    " echo zenkakulist[key]
    substitute(,zenkakuList[key],key)
  endfor
endfunction
""##########
""  Count
""##########
command! Count %s/./&/g  "テキスト内の文字数をカウントする
""########
""  Run
""########
"noremap <F5> <ESC>:QuickRun<CR>
""################
""  Neocomplete
""################
if has('lua')
  NeoBundle 'Shougo/neocomplete.vim'



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
    " return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
  " <C-h>, <BS>: close popup and delete backword char.
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
  inoremap <expr><C-y>  neocomplete#close_popup()
  inoremap <expr><C-e>  neocomplete#cancel_popup()
  " Close popup by <Space>.
  "inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

  " For cursor moving in insert mode(Not recommended)
  "inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
  "inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
  "inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
  "inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
  " Or set this.
  "let g:neocomplete#enable_cursor_hold_i = 1
  " Or set this.
  "let g:neocomplete#enable_insert_char_pre = 1

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




endif
""################
""  HTML(ERUBY)
""################
" emmet
NeoBundle 'mattn/emmet-vim'
let g:user_emmet_leader_key='<C-F>'
" endtag comment
" let g:endtagcommentFormat = '<!-- /%tag_name%id%class -->'
" nnoremap ,t :<C-u>c<!-- / -->ll Endtagcomment()<CR>
" eruby
" autocmd BufEnter * if &filetype == 'eruby' |  setlocal omnifunc=htmlcomplete#CompleteTags | endif
"############################################################
"" Vim-latex (with platex and omake)
"############################################################
"let tex_flavor='latex'
"set grepprg=grep\ -nH\ $*
"set shellslash
"let tex_flavor='latex'
"let g:Tex_DefaultTargetFormat='pdf'
"let g:Tex_CompileRule_dvi='platex $*.tex'
"let g:Tex_CompileRule_pdf='dvipdfmx $*.dvi'
"let g:Tex_FormatDependency_pdf='dvi,pdf'
"" PDFはPreview.appで開く
"let g:Tex_ViewRule_pdf='open -a Preview.app'
""#################
""  Open Browser
""#################
" let g:openbrowser_browser_commands = { "name": "xdg-open", "args": ["{browser}", "{uri}"] }
""#############
""  Filetype
""#############
filetype plugin indent on
syntax on
autocmd BufEnter,BufRead *.conf set ft=conf
autocmd BufEnter * if &filetype == '' | setlocal filetype=text | endif
"#########
""  LISP
""######## http://jiroukaja-memo.hatenablog.com/entry/2013/05/06/010315
"function! s:generate_lisp_tags()
"  let g:slimv_ctags =  'ctags -a -f '.$HOME.'/.vim/tags/lisp.tags '.expand('%:p').' --language-force=Lisp'
"  call SlimvGenerateTags()
"endfunction
"command! -nargs=0 GenerateLispTags call <SID>generate_lisp_tags()
"function! s:generate_lisp_tags_recursive()
"  let g:slimv_ctags =  'ctags -a -f '.$HOME.'/.vim/tags/lisp.tags -R '.expand('%:p:h').' --language-force=Lisp'
"  call SlimvGenerateTags()
"endfunction
"command! -nargs=0 GenerateLispTagsRecursive call <SID>generate_lisp_tags_recursive()
"let g:slimv_repl_split = 4
"let g:slimv_repl_name = 'REPL'
"let g:slimv_repl_simple_eval = 0
"let g:slimv_lisp = '/usr/local/bin/clisp'
"let g:slimv_impl = 'clisp'
"let g:slimv_preferred = 'clisp'
"let g:slimv_swank_cmd = '!osascript -e "tell application \"Terminal\" to do script \"clisp '.$HOME.'/.vim/bundle/slimv/slime/start-swank.lisp\""'
"let g:lisp_rainbow=1
"let g:paredit_mode=1
"let g:paredit_electric_return = 0
"autocmd BufNewFile,BufRead *.asd   set filetype=lisp
""#############
""  Markdown
""#############
NeoBundle "joker1007/vim-markdown-quote-syntax"
NeoBundle 'kannokanno/previm'
NeoBundle "rcmdnk/vim-markdown"
autocmd BufRead,BufNewFile *.{md,mdwn,mkd,mkdn,mark} set filetype=markdown
let g:vim_markdown_folding_disabled=1
let g:vim_markdown_liquid=1
let g:vim_markdown_frontmatter=1
let g:vim_markdown_math=1
" let g:previm_open_cmd
"" Instance markdown preview
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0
""############
""  Haskell
""############
"便利なghcmodなるコマンドをvimから便利に使うためのプラグイン
" NeoBundle 'eagletmt/ghcmod-vim'
"補完用
" NeoBundle 'eagletmt/neco-ghc'
"インデントを賢くしてくれる
"NeoBundle 'kana/vim-filetype-haskell'
""############
""  Comment
""############
imap <C-K> <Esc><Plug>(caw:i:toggle)a
nmap <C-K> <Plug>(caw:i:toggle)
vmap <C-K> <Plug>(caw:i:toggle)
" comment block
inoremap <silent>  """   <C-R>=CommentBlock(input("Enter comment: "),'""','#')<CR>
inoremap <silent>  ///   <C-R>=CommentBlock(input("Enter comment: "),'//','*')<CR>
inoremap <silent>  %%%   <C-R>=CommentBlock(input("Enter comment: "),'%%','*')<CR>
inoremap <silent>  """   <C-R>=CommentBlock(input("Enter comment: "),'""','#')<CR>
function! CommentBlock(comment, ...)
  let introducer =  a:0 >= 1  ?  a:1  :  "//"
  let box_char   =  a:0 >= 2  ?  a:2  :  "*"
  let width      =  a:0 >= 3  ?  a:3  :  strlen(a:comment) + 5
  " Build the comment box and put the comment inside it...
  return introducer . repeat(box_char,width) . "\<CR>"
        \    . introducer . "\<Tab>" . a:comment   . "\<CR>"
        \    . introducer . repeat(box_char,width) . "\<CR>"
endfunction
""#############
""  Pathogen
""#############
" call pathogen#infect()
