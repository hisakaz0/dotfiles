#!/usr/bin/env bash

set -eu

: "other tools" && {
	echo
	echo ">>> install other tools..."
	# python uv
	curl -LsSf https://astral.sh/uv/install.sh | sh
	# vim plug
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

