#!/bin/bash
cd `dirname $0`
for file in `ls -a`
do
  if [ "$file" = "." -o \
       "$file" = ".." -o \
       "$file" = ".gitignore" -o \
       "$file" = "README.md" -o \
       "$file" = ".DS_Store" -o \
       "$file" = ".git" -o \
       "$file" = "setup.sh" ] ; then
    continue
  fi
  echo ln -sf $file $HOME/
done
