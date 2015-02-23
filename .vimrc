""##########
""  Remap
""##########
inoremap OA <Up>
inoremap OB <Down>
inoremap OC <Right>
inoremap OD <Left>
" set ttimeout
" set timeoutlen=50
""######################
""  Neobundle setting
""######################
set runtimepath+=~/.vim/bundle/neobundle.vim/
call neobundle#rc(expand('~/.vim/bundle'))
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
" add plugins
" NeoBundleCheck
""#############
""  Behavior
""#############
set showmatch
set mouse=a
set nf=alpha
set backspace=indent,eol,start
" "set spell
""###########
""  Indent
""###########
set cindent
set expandtab
set shiftwidth=2
set tabstop=2
NeoBundle 'nathanaelkane/vim-indent-guides'
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 1
let g:indent_guides_guide_size=1
""###############
""  Completion
""###############
set wildmode=list,longest
NeoBundle 'MetalPhaeton/easybracket-vim'
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>
""###############
""  Appearance
""###############
colorscheme peachpuff
set number
set title
set list
set listchars=tab:..,trail:_,eol:§,extends:>,precedes:<,nbsp:%
" set cursorline
" set cursorcolumn
set showcmd
set cmdheight=2
set laststatus=2
set statusline=%F%m%r%h%w
set statusline+=%=
set statusline+=[TYPE=%Y]/
set statusline+=[FORMAT=%{&ff}]/
set statusline+=[ENC=%{&fileencoding}]/
set statusline+=[LOW=%l/%L]/
set statusline+=[COLUM=%c/%{col('$')-1}]
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
set hlsearch
noremap <Esc><Esc> :set hlsearch! hlsearch?<CR>
"########################
""  Windows like keymap
"########################
inoremap <C-s> <Esc>:w<CR>a
inoremap <C-q> <Esc>:q<CR>
nnoremap <C-s> <Esc>:w<CR>
nnoremap <C-q> <Esc>:q<CR>
""##########
""  Aided
""##########
" shift押すのがめんどくさい
nnoremap ; :
vnoremap ; :
" トグルスイッチ
set pastetoggle=<F4>
" convert markdown to html
command Mth :!mth %
" インデント調整
map  <C-/>
inoremap  <C-/>
inoremap <C-/> <Esc>:call CorrectCode()<CR>a
nnoremap <C-/> :call CorrectCode()<CR>
function CorrectCode()
  execute ":mkview"
  execute ":normal gg=G"
  execute ":loadview"
endfunction
" 行末の空白を削除
NeoBundle 'bronson/vim-trailing-whitespace'
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
command Count %s/./&/g  "テキスト内の文字数をカウントする
""########
""  Run
""########
noremap <F5> <ESC>:call RUN()<ENTER>
function! RUN()
  if &filetype == 'sh'
    :w|!php %;read
  endif
  if &filetype == 'php'
    :w|!php %;read
  endif
  if &filetype == 'markdown'
    :PrevimOpen
  endif
endfunction
""################
""  Neocomplete
""################
if has('lua')
  NeoBundle 'Shougo/neocomplete.vim'
  " Disable AutoComplPop.
  let g:acp_enableAtStartup = 0
  " Use neocomplete.
  let g:neocomplete#enable_at_startup = 1
  " Use smartcase.
  let g:neocomplete#enable_smart_case = 1
  " Set minimum syntax keyword length.
  let g:neocomplete#sources#syntax#min_keyword_length = 2
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
  " Define dictionary.
  let g:neocomplete#sources#dictionary#dictionaries = {
        \ 'default'   : '',
        \ 'vimshell'  : $HOME.'/.vimshell_hist',
        \ 'scheme'     : $HOME.'/.gosh_completions',
        \ 'html'    : $HOME.'/.vim/dict/html.dict',
        \ 'php'      : $HOME.'/.vim/dict/php.dict',
        \ 'css'     : $HOME.'/.vim/dict/css.dict',
        \ 'c'       : $HOME.'/.vim/dict/c.dict',
        \ 'tex'     : $HOME.'/.vim/dict/tex.dict',
        \ 'java'    : $HOME.'/.vim/dict/java.dict'
        \ }
  " keymapping
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
    return neocomplete#close_popup() . "\<CR>"
    " For no inserting <CR> key.
    "return pumvisible() ? neocomplete#close_popup() : "\<CR>"
  endfunction
  " <TAB>: completion.
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"
  inoremap <expr><Up> pumvisible() ? neocomplete#close_popup()."\<Up>" : "\<Up>"
  inoremap <expr><Down> pumvisible() ? neocomplete#close_popup()."\<Down>" : "\<Down>"
  inoremap <expr><MouseDown> pumvisible() ? neocomplete#close_popup()."\<MouseDown>" : "\<MouseDown>"
  inoremap <expr><MouseUp> pumvisible() ? neocomplete#close_popup()."\<MouseUp>" : "\<MouseUp>"
  inoremap <expr><PageDown> pumvisible() ? neocompe#close_popup()."\<PageDown>" : "\<PageDown>"
  inoremap <expr><PageUp> pumvisible() ? neocomplete#close_popup()."\<PageUp>" : "\<PageUp>"
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
  autocmd FileType php setlocal omnifunc=phpcomplete#CompleteTags
  " Enable heavy omni completion.
  if !exists('g:neocomplete#sources#omni#input_patterns')
    let g:neocomplete#sources#omni#input_patterns = {}
  endif
  let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
  "let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
  "let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  " For perlomni.vim settinendendif
  " https://github.com/c9s/perlomni.vim
  ""let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
endif

"############################################################
"" Vim-latex (with platex and omake)
"############################################################
let tex_flavor='latex'
set grepprg=grep\ -nH\ $*
set shellslash
let tex_flavor='latex'
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_dvi='platex $*.tex'
let g:Tex_CompileRule_pdf='dvipdfmx $*.dvi'
let g:Tex_FormatDependency_pdf='dvi,pdf'
" PDFはPreview.appで開く
let g:Tex_ViewRule_pdf='open -a Preview.app'
""###############################
""  Hyper Text Markup Language
""###############################
autocmd BufNewFile *.html 0r $HOME/.vim/templates/skel.html
""#################
""  Open Browser
""#################
" let g:openbrowser_browser_commands = { "name": "xdg-open", "args": ["{browser}", "{uri}"] }
""#####################
""  Filetype setting
""#####################
filetype plugin indent on
syntax on
""#########
""  LISP
""######### http://jiroukaja-memo.hatenablog.com/entry/2013/05/06/010315
function! s:generate_lisp_tags()
  let g:slimv_ctags =  'ctags -a -f '.$HOME.'/.vim/tags/lisp.tags '.expand('%:p').' --language-force=Lisp'
  call SlimvGenerateTags()
endfunction
command! -nargs=0 GenerateLispTags call <SID>generate_lisp_tags()
function! s:generate_lisp_tags_recursive()
  let g:slimv_ctags =  'ctags -a -f '.$HOME.'/.vim/tags/lisp.tags -R '.expand('%:p:h').' --language-force=Lisp'
  call SlimvGenerateTags()
endfunction
command! -nargs=0 GenerateLispTagsRecursive call <SID>generate_lisp_tags_recursive()
let g:slimv_repl_split = 4
let g:slimv_repl_name = 'REPL'
let g:slimv_repl_simple_eval = 0
let g:slimv_lisp = '/usr/local/bin/clisp'
let g:slimv_impl = 'clisp'
let g:slimv_preferred = 'clisp'
let g:slimv_swank_cmd = '!osascript -e "tell application \"Terminal\" to do script \"clisp '.$HOME.'/.vim/bundle/slimv/slime/start-swank.lisp\""'
let g:lisp_rainbow=1
let g:paredit_mode=1
let g:paredit_electric_return = 0
autocmd BufNewFile,BufRead *.asd   set filetype=lisp
""##############################
""  Instance markdown preview
""##############################
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0
""#############
""  Markdown
""#############
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'kannokanno/previm'
augroup MD
  autocmd BufRead,BufNewFile *.{md,mdwn,mkd,mkdn,mark} set filetype=markdown
  autocmd BufRead,BufNewFile *.txt set filetype=markdown
  autocmd BufEnter * if &filetype == '' | setlocal filetype=markdown | endif
  autocmd FileType markdown  setlocal shiftwidth=2
  autocmd FileType markdown  setlocal tabstop=2
augroup END
let g:vim_markdown_folding_disabled=0
let g:vim_markdown_liquid=1
let g:vim_markdown_frontmatter=1
let g:vim_markdown_math=1
" let g:previm_open_cmd
""############
""  Haskell
""############
"便利なghcmodなるコマンドをvimから便利に使うためのプラグイン
" NeoBundle 'eagletmt/ghcmod-vim'
"補完用
" NeoBundle 'eagletmt/neco-ghc'
"インデントを賢くしてくれる
NeoBundle 'kana/vim-filetype-haskell'
""############
""  Comment
""############
imap <C-K> <Esc><Plug>(caw:i:toggle)a
nmap <C-K> <Plug>(caw:i:toggle)
vmap <C-K> <Plug>(caw:i:toggle)
" comment block
inoremap <silent>  """  <C-R>=CommentBlock(input("Enter comment: "),'""','#')<CR>
inoremap <silent>  ///  <C-R>=CommentBlock(input("Enter comment: "),'//','*')<CR>
inoremap <silent>  %%%  <C-R>=CommentBlock(input("Enter comment: "),'%%','*')<CR>
inoremap <silent>  """  <C-R>=CommentBlock(input("Enter comment: "),'""','#')<CR>
inoremap <silent>  ---  <C-R>=CommentBlock(input("Enter comment: "),'--','*')<CR>
if &filetype != 'markdown'
  imap <silent>  ###  <C-R>=CommentBlock(input("Enter comment: "),'##','#')<CR>
endif
function CommentBlock(comment, ...)
  let introducer =  a:0 >= 1  ?  a:1  :  "//"
  let box_char   =  a:0 >= 2  ?  a:2  :  "*"
  let width      =  a:0 >= 3  ?  a:3  :  strlen(a:comment) + 5
  " Build the comment box and put the comment inside it...
  return introducer . repeat(box_char,width) . "\<CR>"
        \    . introducer . "\<Tab>" . a:comment   . "\<CR>"
        \    . introducer . repeat(box_char,width) . "\<CR>"
endfunction
""#######################
""  ごみいちゃん
""#######################
"" map
" map OA <Up>
" map OB <Down>
" map OC <Right>
" map OD <Left>
" set t_ku=OA
" set t_kd=OB
" set t_kr=OC
" set t_kl=OD
" set nocompatible
"" 挿入モード時にctrl + rで置換
" inoremap <C-r> <Esc>:call ReplaceonInsertMode()<CR>i
" function! ReplaceonInsertMode()
"   call inputsave()
"   let l:before=input("Befor:")
"   let l:after=input("Aefor:")
"   execute ":%s/".l:before."/".l:after."/gc"
"   call inputrestore()
" endfunction
"" default indent-guides setting"
" autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
" autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
" inoremap <silent>  DDD  <C-R>=CommentBlock(strftime("%Y/%m/%d"),'--','-',80)<CR>
" inoremap <silent> AAA   <C-R>=HeaderBlock(input("Author : "))<CR>
