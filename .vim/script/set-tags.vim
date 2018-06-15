
command! -nargs=0
      \ SetCwdTagFile
      \ call SetTagFiles('tags')

command! -nargs=1 -complete=file
      \ SetTagFile
      \ call SetTagFiles(<f-args>)

command! -nargs=+ -complete=file
      \ SetTagFiles
      \ call SetTagFiles(<f-args>)

func! GetFullPath(file)
  return getcwd() . '/' . a:file
endfunc

func! SetTagFiles(...)
  for path in a:000
    let s:tag_file = GetFullPath(path)
    let &tags = s:tag_file . ',' . &tags
  endfor
endfunc
