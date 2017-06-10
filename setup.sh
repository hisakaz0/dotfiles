#!/bin/bash
dotfiles_root=$(cd $(dirname $0) && pwd)
list=(.bashrc .config .cshrc .cshrc.body .gitconfig .inputrc .tmux.conf .vim/after .vim/autoload .vim/plugin .vim/templates .vim/colors .vimrc .screenrc .hammerspoon/init.lua)
cd $HOME
for file in ${list[*]}
do
  src="$dotfiles_root/$file"
  dist="$HOME/${file%\/*}"
  if [ "${file%\/*}" != "$file" ] && [ ! -d "$dist" ] ; then
    echo "Make directory: $dist"
    mkdir -p "$dist"
  fi
  cmd="ln -sf $src $dist"

  echo $cmd ; $cmd
done
