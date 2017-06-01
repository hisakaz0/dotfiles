#!/bin/bash
dotfiles_root=$(cd $(dirname $0) && pwd)
list=(.bashrc .config .cshrc .cshrc.body .gitconfig .inputrc .tmux.conf .vim/after .vim/autoload .vim/plugin .vim/templates .vim/colors .vimrc .screenrc)
cd $HOME
for file in ${list[*]}
do
  src="$dotfiles_root/$file"
  dict="$HOME/${file%\/*}"
  cmd="ln -sf $src $dict"

  echo $cmd ; $cmd
done
