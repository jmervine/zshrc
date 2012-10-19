#!/usr/bin/env bash

files=( $( ls -a -d1 .* | grep -v .git | xargs echo ) )
for file in "${files[@]}"
do
  test -L ~/$file && rm -v ~/$file
  test -f ~/$file && mv -v ~/$file ~/$file.bak
  test -f $file && \
    ln -v -s $(pwd)/$file ~/$file
done
