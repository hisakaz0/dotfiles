" Vim global plugin for opening recently files more easier.
" Last Change:   2016 Aug 05
" Maintainer:    hisakazu <cantabilehisa@gmail.com>
" License:       MIT License

let s:save_cpo = &cpo
set cpo&vim

if exists("g:loaded_openrcnt")
  finish
endif
let g:loaded_openrcnt = 1


if !exists(":RecentList")
  command RecentList call s:Filelist()
endif


function s:Filelist()
  let s:bufname = "__RECENT__"
  if bufexists(s:bufname)
    return
  endif
  execute "silent new " . s:bufname
  silent put =v:oldfiles
  silent 1,1delete
  silent setlocal bufhidden=delete
  silent setlocal buftype=nowrite
  silent setlocal noswapfile
  silent setlocal nomodifiable
  silent setlocal nobuflisted
endfunction

function s:Editfile()
  let s:file = getline('.')
  execute "new " . s:file
endfunction

noremap <unique> <script> <Plug>OpenrcntEditfile  <SID>Editfile
noremap <SID>Editfile  :call <SID>Editfile()<CR>

function s:Setmap()
  if !hasmapto('<Plug>OpenrcntEditfile')
    nmap <buffer> l  <Plug>OpenrcntEditfile
  endif
endfunction

autocmd BufEnter __RECENT__  call s:Setmap()


" restore-cpo
let &cpo = s:save_cpo
unlet s:save_cpo
