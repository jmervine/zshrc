[[ -e ~/.localrc ]] && . ~/.localrc # run first

#############################################################
# If ZSH use ZSH
#############################################################
( ( [[ -x /usr/local/bin/zsh-4.3.17 ]] && /usr/local/bin/zsh-4.3.17 && exit ) || ( [[ ! "`which zsh`" =~ "not found" ]] && zsh && exit ) )


#############################################################
# Externals
#############################################################
#
. ~/.pathrc # export PATH here
. ~/.aliasrc # set aliases here
. ~/.functionrc

#############################################################
# Ruby Environments
#############################################################
#
# TPKG installs on corp boxes
[[ -d /home/t/ruby-1.9.2-p290-2/bin ]] && export PATH="/home/t/ruby-1.9.2-p290-2/bin:$PATH"
[[ -d /home/t/sbin ]] && export PATH="/home/t/sbin:$PATH"


#############################################################
# ConqueTerm - VIM plugin handling
#############################################################
#
if [ "$CONQUE" == "" ]; then
	source ~/bin/java_profile
	source ~/bin/cloud_profile
fi


#############################################################
# Source Prompt
#############################################################
source ~/bin/git_profile


#############################################################
# History Config
#############################################################
#
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

#############################################################
# Run sync_install.sh
#############################################################
#
[[ -e ~/bin/sync_install.sh ]] && /bin/bash ~/bin/sync_install.sh

#############################################################
# Add ssh host autocompletion from known_hosts file
#############################################################
#
complete -W "$(echo `cat ~/.ssh/known_hosts | cut -f 1 -d ' ' | sed -e s/,.*//g | uniq | grep -v "\["`;)" ssh

