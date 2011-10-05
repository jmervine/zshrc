export SVN_EDITOR="vim"
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$HOME/Scripts:$HOME/bin:$HOME/sbin:/Users/jmervine/sbin/homebrew/bin:$PATH

# set bash to vim bind mode
#set -o vi
#bind '"":ed-clear-screen'
#alias cl="clear"

# cloud switch
function cloud {
	echo "setting up \"$1\" cloud environment"
	echo "------------------------------------------------"
	case $1 in
	"aws")
		# clean up
		unset `env | grep "AWS\|EC2\|S3" | awk -F= '{ print $1 }' | xargs`
		source ~/.ec2/awsrc
		;;
	"ops")
		# clean up
		unset `env | grep "AWS\|EC2\|S3" | awk -F= '{ print $1 }' | xargs`
		source ~/.ec2/opsrc
		;;
	*)
		echo "Unknown cloud set."
		;;
	esac
	env | grep "AWS\|EC2\|S3\|AMAZON" | sort
	echo "------------------------------------------------"
}
cloud ops

# getting fancey with JAVA_HOME
if [ "`uname`" == "Darwin" ]; then
	export JAVA_HOME="/System/Library/Frameworks/JavaVM.framework/Home"
else
	if [ -e ~/.javahome ]; then 
		source ~/.javahome
	else
		echo "!!WARNING!!"
		echo "Can't set JAVA_HOME!"
		echo "Please create ~/.javahome with valid export command."
	fi
fi

# git alias
alias gitweb="git instaweb --httpd=webrick"

# Git bash completion
[ -f ~/.git-bash-completion.sh ] && . ~/.git-bash-completion.sh

# Git show branch
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[0;33m\]"
 	  GREEN="\[\033[0;32m\]"
       BLUE="\[\033[0;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[1;37m\]"
 LIGHT_GRAY="\[\033[0;37m\]"
 COLOR_NONE="\[\e[0m\]"

function parse_git_branch {

  git rev-parse --git-dir &> /dev/null
  git_status="$(git status 2> /dev/null)"
  branch_pattern="^# On branch ([^${IFS}]*)"
  remote_pattern="# Your branch is (.*) of"
  diverge_pattern="# Your branch and (.*) have diverged"
  if [[ ! ${git_status}} =~ "working directory clean" ]]; then
    state="${RED}⚡"
  fi
  # add an else if or two here if you want to get more specific
  if [[ ${git_status} =~ ${remote_pattern} ]]; then
    if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
      remote="${YELLOW}↑"
    else
      remote="${YELLOW}↓"
    fi
  fi
  if [[ ${git_status} =~ ${diverge_pattern} ]]; then
    remote="${YELLOW}↕"
  fi
  if [[ ${git_status} =~ ${branch_pattern} ]]; then
    branch=${BASH_REMATCH[1]}
    echo " (${branch})${remote}${state}"
  fi
}

function prompt_func() {
    previous_return_value=$?;
    # prompt="${TITLEBAR}$BLUE[$RED\w$GREEN$(__git_ps1)$YELLOW$(git_dirty_flag)$BLUE]$COLOR_NONE "
    prompt="${TITLEBAR}${BLUE}[${RED}(\!) \u@\h: \w${GREEN}$(parse_git_branch)${BLUE}]${COLOR_NONE} "
    if test $previous_return_value -eq 0
    then
        PS1="${prompt}➔ "
    else
        PS1="${prompt}${RED}➔${COLOR_NONE} "
    fi
}

PROMPT_COMMAND=prompt_func

function gitwho() {
  git_current="`git config --global --get user.email`"
  if [ "$1" == "" ]; then
    echo $git_current
  else
    if [ "$1" == "switch" ]; then
      if [ "$git_current" == "joshua@mervine.net" ]; then
        email="jmervine@attinteractive.com"
      else
        email="joshua@mervine.net"
      fi
    else
      email="$1"
    fi
    git config --global user.email "$email"
    git config --global --get user.email
  fi

}

# rvm 
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" # Load RVM function

# oracle client
export DYLD_LIBRARY_PATH="/usr/local/oracle/instantclient_10_2"
export ARCHFLAGS="-arch x86_64"

# my lshost.rb script 
alias lh="ruby /Users/jmervine/bin/lshost.rb"
alias lk="~/sbin/list_known.sh"

# history config
HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

# ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
}

# Source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

function decrypt {
        # decrypt if selected
        FILE=$1
        echo "-> decrypt: $(basename $FILE) "
        openssl enc -d -aes-256-cbc -salt -in "$FILE" -out "${FILE/.enc/}"
        FILE=""
}
 
function encrypt {
        # encrypt if selected
        FILE=$1
        echo "-> encrypt: $(basename $FILE) "
        openssl enc -e -aes-256-cbc -salt -in "$FILE" -out "$FILE.enc"
        FILE=""
}

function clipboard {
	if [ -e ~/Dropbox/Work/clipboard.txt ]; then 
		if [ "$1" == "" ]; then
			cat ~/Dropbox/Work/clipboard.txt
		else
			echo "$1" > ~/Dropbox/Work/clipboard.txt
		fi
	fi
}

alias src="source ~/.profile || source ~/.bash_profile || source ~/.bashrc"


