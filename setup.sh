#!/usr/bin/env bash

set -eu
#set -x # debug

dotfiles_root=$(pwd)

# @param array list
#   The `list` variable containes list of src file/directory
#   which will be linked to actual config one. The path is relative
#   path from project root.

: "preprocess" && {
  cd $(dirname $0)
  list=$(cat list)
  PATH="$(pwd)/script:$PATH"
}

: "main" && {
  cd $HOME
  for file in ${list[*]}
  do
    src="$dotfiles_root/$file"
    dist="$HOME/$file"
    make_parent_directory "$dist"
    make_symbolic_link "$src" "$dist"
  done
}

: "brew" && {
  cd $dotfiles_root
  if type brew &>/dev/null ; then
    brew bundle
    brew bundle cleanup
  fi
}
