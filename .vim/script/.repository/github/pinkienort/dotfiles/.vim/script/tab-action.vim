
function! ActionTabKey()
endfunction

function! ActionShiftTabKey()
  call LeftShiftOneTab
endfunction

function! LeftShiftOneTab()
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

function! RightShiftOneTab()
  let s:pos = getpos('.')
  let s:line = getline('.')
  let s:i = 0
  if (&expandtab)
    let s:space_char = ' '
    let s:volume = &tabstop
  else
    let s:space_char = '	'
    let s:volume = 1
  endif
  while (s:i < s:volume)
    let s:line = s:space_char . s:line
    let s:i = s:i + 1
  endwhile
  let s:pos[2] = s:pos[2] + s:i
  call setline('.', s:line)
  call setpos('.', s:pos)
endfunction

function! IsMarkdownList()
  let s:line = getline('.')
  let s:index = 0
  let s:flag_symbol_is_appeared = v:false
  while (s:index < len(s:line))
    let s:char = s:line[s:index]
    if (s:char == ' ' || s:char == '	')
      if (s:flag_symbol_is_appeared)
        return v:true
      endif
      s:index += 1
    elseif (s:char == '*' || s:char == '-')
      s:flag_symbol_is_appeared = v:true
      s:index += 1
    else
      return v:false
    endif
  endwhile
  throw 'Illegal state exception'
endfunction
