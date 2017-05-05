#!/bin/bash
dotfiles_root=$(cd $0; pwd)
dotfiles_root=${dotfiles_root#$HOME\/} # relative path
list=`ls -a`
ignore_list=( \
  "." \
  ".." \
  ".git" \
  ".DS_Store" \
  ".gitignore" \
  "README.md" \
  "setup.sh" \
)
cd $HOME
for file in $list
do
  ignore_flag=0
  for ignore in ${ignore_list[@]}
  do
    [ "$ignore" = "$file" ] && ignore_flag=1
  done
  if [ $ignore_flag -eq 1 ] ; then
    echo ">> '$file' is ignored." 1>&2
  else
    cmd="ln -is $dotfiles_root/$file $HOME"
    echo $cmd ; $cmd
  fi
done
