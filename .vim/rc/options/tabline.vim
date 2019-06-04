
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

set tabline=%!MyTabLine()
set showtabline=2

