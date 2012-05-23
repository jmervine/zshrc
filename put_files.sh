#!/bin/bash
# run this from with in dotfiles directory

files=( .aliasrc  .functionrc  .git-bash-completion.sh  .gitconfig  .gitignore  .pathrc  .profile  .zshrc )

for f in "${files[@]}"
do
        echo "cp $f ~/$f"
done

