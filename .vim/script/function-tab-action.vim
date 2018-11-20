"
function! ActionKeyShiftTab()
  call LeftShiftOneTab()
endfunction

function! ActionKeyTab()
  if (IsMarkdownList())
    call RightShiftOneTab()
  else
    call AppendOneTab()
  endif
endfunction

function! IsExpandTab()
    return &expandtab
endfunction

function! IsNotExpandTab()
    return ! IsExpandTab()
endfunction

function! LeftShiftOneTab()
  let s:pos  = getpos('.')
  let s:line = getline('.')
  let s:i = 0
  let s:space = ' '
  let s:volume = &tabstop
  if (IsNotExpandTab())
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
  let s:index = 0
  if (IsExpandTab())
    let s:space_char = ' '
    let s:volume = &tabstop
  else
    let s:space_char = '	'
    let s:volume = 1
  endif
  while (s:index < s:volume)
    let s:line = s:space_char . s:line
    let s:index = s:index + 1
  endwhile
  let s:pos[2] = s:pos[2] + s:index
  call setline('.', s:line)
  call setpos('.', s:pos)
endfunction

function! AppendOneTab()
  let s:pos = getpos('.')
  let s:line = getline('.')
  let s:INDEX_COLUMN_POS = 2
  let s:index_current_column = s:pos[s:INDEX_COLUMN_POS]
  if (IsExpandTab())
    let s:line = strpart(s:line, 0, s:index_current_column)
          \ . repeat(' ', &tabstop) . strpart(s:line, s:index_current_column)
    let s:pos[s:INDEX_COLUMN_POS] = s:pos[s:INDEX_COLUMN_POS] + &tabstop + 1
  else
    let s:line = strpart(s:line, 0, s:index_current_column)
          \ . '	' . strpart(s:line, s:index_current_column)
    let s:pos[s:INDEX_COLUMN_POS] = s:pos[s:INDEX_COLUMN_POS] + 2
  endif
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
      let s:index = s:index + 1
    elseif (s:char == '*' || s:char == '-')
      return v:true
    else
      return v:false
    endif
  endwhile
  return v:true
endfunction

function! IsNotMarkdownList()
  return ! IsMarkdownList()
endfunction
