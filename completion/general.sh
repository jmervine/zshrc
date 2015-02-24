###############################################################
# Completion
###############################################################
CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
setopt bash_autolist
autoload -U compinit && compinit
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'

local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts
zstyle ':completion:*' hosts off
autoload -U zmv

# git
this_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
zstyle ':completion:*:*:git:*' script ${this_dir}/.git-completion.zsh
