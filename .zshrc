[[ -e ~/.localrc ]] && . ~/.localrc # run first

export EDITOR=vim
bindkey -v
bindkey '^R' history-incremental-search-backward

###############################################################
# Completion
###############################################################
CASE_SENSITIVE="true"
COMPLETION_WAITING_DOTS="true"
setopt bash_autolist
autoload -U compinit && compinit
zstyle ':completion:*:*:kill:*:processes' command 'ps --forest -e -o pid,user,tty,cmd'
zstyle ':completion:*' hosts off
autoload -U zmv


###############################################################
# Externals
###############################################################
#
. ~/.pathrc # paths
. ~/.aliasrc # aliases
. ~/.functionrc # functions

###############################################################
# History
###############################################################
setopt inc_append_history
setopt share_history
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
unsetopt correct_all

###############################################################
# Directory Navigation
###############################################################
# remember directories you've navigated through
# dirs -v to list
# cd +1 to jump to dir 1 from top
# cd -3 to jump to dir 3 from bottom
setopt AUTO_PUSHD

###############################################################
# Overwrite globals
###############################################################
alias src=". ~/.zshrc"


###############################################################
# Prompt
###############################################################
function git_branch_string {
        echo "`git status | grep "^# On branch .*$" | cut -d " " -f 4`"
}

function git_branch {

        RED="%{$fg[red]%}"
        GREEN="%{$fg[green]%}"
        YELLOW="%{$fg[yellow]%}"

        git rev-parse --git-dir &> /dev/null

        git_status="$(git status 2> /dev/null)"
        branch_pattern="^# On branch (.*)$"
        remote_pattern="# Your branch is (.*) of"
        diverge_pattern="# Your branch and (.*) have diverged"
        ahead_pattern="^# Your branch is ahead of"

        if [[ ! ${git_status} =~ "working directory clean" ]]; then
            state=" ${RED}⚡"
        fi
        
        if [[ ${git_status} =~ ${remote_pattern} ]]; then
            if [[ ${git_status} =~ ${ahead_pattern} ]]; then
              remote=" ${YELLOW}↑"
            else
              remote=" ${YELLOW}↓"
            fi
        fi

        if [[ ${git_status} =~ ${diverge_pattern} ]]; then
            remote=" ${YELLOW}↕"
        fi

        if [[ ${git_status} =~ ${branch_pattern} ]]; then
            branch="`git_branch_string`"
            echo " ${branch}${remote}${state}"
        fi
        
}

function ruby_version {
        echo `ruby -v | cut -d " " -f 2` 2>/dev/null
}

function zle-line-init zle-keymap-select {
    local old_ps1="${PS1:0:-2}"
    PS1="$old_ps1${${KEYMAP/vicmd/:}/(main|viins)/$} "
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

function precmd() {
        local p_git_branch="`git_branch`"
        local p_ruby_version="ruby-`ruby_version`%{$reset_color%}"
        local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

        test "$PS_SIGN" || export PS_SIGN="[I] "

        PS1="%{$fg[yellow]%}[%n@%m] %{$fg[blue]%}%~%{$reset_color%} $ "
        #PS1="%{$fg[yellow]%}[%n@%m] %{$fg[blue]%}%~ %{$reset_color%}${PS_SIGN} "
        RPROMPT="%{$fg[red]%}${return_code} %{$reset_color%} [ ${p_git_branch}%{$reset_color%} | ${p_ruby_version} |%t ]"
}

autoload -U colors && colors


PATH=$PATH:$HOME/.rvm/bin:$HOME/Scripts # Add RVM to PATH for scripting
