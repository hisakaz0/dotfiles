#!/usr/bin/env bash

set -eu
#set -x # debug

dotfiles_root=$(pwd)

# @param array list
#   The `list` variable containes list of src file/directory
#   which will be linked to actual config one. The path is relative
#   path from project root.

: "pre-process" && {
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

: "vim" && {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/Shougo/dein-installer.vim/master/installer.sh)"
}

: "brew" && {
  cd $dotfiles_root
  if type brew &>/dev/null ; then
    brew bundle
    brew cleanup
    brew autoremove
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}

: "mac" && {
  # long pressでアクセント付き文字のポップアップを無効にする
  defaults write -g ApplePressAndHoldEnabled -bool false

  echo "スクリーンショットの保存ディレクトリの変更"
  echo "https://www.reddit.com/r/macbookair/comments/1cg075e/how_can_i_change_the_default_folder_on_a_mac/"
}

