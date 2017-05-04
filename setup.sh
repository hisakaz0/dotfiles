#!/bin/bash
cd `dirname $0`
pwd=`pwd`
ignore_list=( \
  "." \
  ".." \
  ".git" \
  ".DS_Store" \
  ".gitignore" \
  "README.md" \
  "setup.sh" \
)
for file in `ls -a`
do
  ignore_flag=0
  for ignore in ${ignore_list[@]}
  do
    [ "$ignore" = "$file" ] && ignore_flag=1
  done
  [ $ignore_flag -eq 1 ] && continue
  cmd="ln -is $pwd/$file $HOME"
  echo $cmd ; $cmd
done
