#!/bin/bash
#
# Setup up the following symlinks:
# -> .git-bash-completion.sh
# -> .gitconfig
# -> .profile
# 


DIR="$( cd "$( dirname "$0" )" && pwd )"

if uname -a | grep Darwin > /dev/null
then
	BRANCH="master"
else
	BRANCH="centos"
fi

echo "Setting branch to '$BRANCH'."

# test to see if I need to checkout code
if [[ $DIR =~ "dotfiles" ]]; then
	echo "Looks like I have what I need to set up you, starting."
else
	echo "Looks like I need to checkout what you need, starting."
	if ! git clone git://github.com/jmervine/dotfiles.git; then
		echo " --> git clone failed, exiting."
		exit 1
	fi
	if [ ! -d ./dotfiles ]; then
		echo " --> Something's wrong, couldn't find git checkout, exiting."
		exit 1
	fi
	DIR="$DIR/dotfiles"
	cd $DIR
	if [ "$BRANCH" != "master" ]; then
		echo "Running git checkout on $BRANCH."
		if ! git checkout -t remotes/origin/$BRACH; then
			echo " --> Something's wrong, couldn't checkout $BRANCH, exiting."
			exit 1
		fi
	fi
fi

function do_file {
	file="$1"
	# setup  
	if [ -e $HOME/.$file ]; then
		if [ -h $HOME/.$file ]; then 
			echo " --> $HOME/.$file exists and is a symlink, deleting."
			rm $HOME/.$file
		else
			echo " --> $HOME/.$file exists and is not a symlink, creating a backup."
			mv $HOME/.$file $HOME/.$file.old
		fi
	fi

	echo "Creating $HOME/.$file -> $DIR/$file symlink."
	ln -s $DIR/$file $HOME/.$file
}

do_file "profile"
do_file "git-bash-completion.sh"
do_file "gitconfig"

