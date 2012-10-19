#!/usr/bin/env bash

files=( $( ls -a -d1 .* | grep -v .git | xargs echo ) )
for files in "${files[@]}"
do
  test -L ~/$file && rm -v ~/$file
  test -f ~/$file && mv -rv "~/$file".bak
  ln -v -s ~/$file  $(pwd)/$file
done
