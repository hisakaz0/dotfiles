#!/bin/bash

set -e
#set -x # debug

# @param array list
#   The `list` variable containes list of src file/directory
#   which will be linked to actual config one. The path is relative
#   path from project root.

: "preprocess" && {
  cd $(dirname $0)
  dotfiles_root=$(pwd)

  list=( \
    .bashrc \
    .config/awesome \
    .config/git \
    .config/nvim \
    .cshrc \
    .cshrc.body \
    .gitconfig \
    .inputrc \
    .tmux.mac.conf \
    .tmux.noplugin.conf \
    .vim/after \
    .vim/autoload \
    .vim/plugin \
    .vim/templates \
    .vim/colors \
    .vimrc \
    .screenrc \
    .hammerspoon/init.lua \
    )
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
