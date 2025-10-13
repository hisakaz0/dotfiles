
""""""""""""""""""""""""""""""""""""""""""""""""""
" Vim Options
""""""""""""""""""""""""""""""""""""""""""""""""""
" 行番号を表示する
set number
" 検索文字列を光らせる
set hlsearch
" 検索開始時にカーソルを移動させる
set incsearch 
" タブサイズ=2。
" tabにするかspaceにするかは後続の filetype indent plugin で決める
set tabstop=2
set shiftwidth=2
" バッファを保存していない状態でも別のバッファを開けるように
set hidden
set helplang=ja,en

""""""""""""""""""""""""""""""""""""""""""""""""""
" Netrw
""""""""""""""""""""""""""""""""""""""""""""""""""
" explorer windowの幅を設定
let g:netrw_winsize = 20
" 1つ前のウィンドウで開く
let g:netrw_browse_split = 4

" Netrwウィンドウを開くか、既存のものにジャンプする関数
function! OpenNetrwOrJump()
	" 既存のNetrwバッファを持つウィンドウを探す
	let l:netrw_winnr = -1
	for l:winnr in range(1, winnr('$'))
		if getbufvar(winbufnr(l:winnr), '&filetype') == 'netrw'
			let l:netrw_winnr = l:winnr
			break
		endif
	endfor

	" Netrwウィンドウが見つかった場合、そこにフォーカスを移動
	if l:netrw_winnr != -1
		" フォーカスをNetrwウィンドウに移動
		execute l:netrw_winnr . 'wincmd w'
	else
		" 見つからなかった場合、新規に左側に垂直分割でNetrwを開く
		Vex
	endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" Key mapping
""""""""""""""""""""""""""""""""""""""""""""""""""
" Netrwを左カラムに起動する。既に起動している場合はそのwindowに移動する
nnoremap <Leader>e :call OpenNetrwOrJump()<CR>

" vimrcを再読み込みする
nnoremap <Leader>r :source ~/.vimrc<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-plug
""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

" List your plugins here
Plug 'vim-jp/vimdoc-ja'

call plug#end()

