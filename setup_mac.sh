#!/usr/bin/env bash

set -eu

: "mac" && {
	echo
	echo ">>> mac setting..."
  # long pressでアクセント付き文字のポップアップを無効にする
  defaults write -g ApplePressAndHoldEnabled -bool false

  echo "次を読んで、スクリーンショットの保存ディレクトリの変更してください"
  echo "https://www.reddit.com/r/macbookair/comments/1cg075e/how_can_i_change_the_default_folder_on_a_mac/"
}

