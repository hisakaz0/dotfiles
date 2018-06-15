
if &compatible
  set nocompatible " Be iMproved
endif

let s:dein_path = expand('~/.cache/dein/repos/github.com/Shougo/dein.vim')
let s:cache_path = expand('~/.cache/dein')
let s:installer_url = "https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh"
let s:installer_path = expand('~/.dein-installer.sh')

let s:config_path = expand('<sfile>:p:h') . '/' . "toml/plugins.toml"
let s:lazy_config_path = expand('<sfile>:p:h') . '/' . "toml/plugins-lazy.toml"

if !isdirectory(s:dein_path)
  echo "Installing dein.vim"
  call system(printf("curl %s > %s && sh %s %s"
        \ , s:installer_url
        \ , s:installer_path
        \ , s:installer_path
        \ , s:cache_path
        \ ))
endif

exe 'set runtimepath^=' . s:dein_path

if dein#load_state(s:cache_path)
  " Required:
  call dein#begin(s:cache_path)

  call dein#load_toml(s:config_path, { 'lazy': 0 })
  call dein#load_toml(s:lazy_config_path, { 'lazy': 1 })

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif
