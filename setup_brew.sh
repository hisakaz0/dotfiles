#!/usr/bin/env bash

set -eu

dotfiles_root=$(pwd)

: "brew" && {
	echo
	echo ">>> brew install..."
  cd $dotfiles_root
  if type brew &>/dev/null ; then
    brew bundle
    brew cleanup
    brew autoremove
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
}
