###############################################################
# Completion
###############################################################
CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
setopt bash_autolist

fpath=(~/.zsh/completion $fpath)
autoload -U compinit && compinit
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'

local knownhosts
knownhosts=( ${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%%\ *}%%,*} )
zstyle ':completion:*:(ssh|scp|sftp):*' hosts $knownhosts
zstyle ':completion:*' hosts off
autoload -U zmv

# git
if test -f ~/.dotfiles/.git-completion.zsh; then
  zstyle ':completion:*:*:git:*' script ~/.dotfiles/.git-completion.zsh
fi
