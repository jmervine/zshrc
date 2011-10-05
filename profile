export SVN_EDITOR="vim"
export PATH=/opt/local/bin:/opt/local/sbin:/usr/local/mysql/bin:$HOME/Scripts:$HOME/bin:$HOME/sbin:/Users/jmervine/sbin/homebrew/bin:$PATH

# set bash to vim bind mode
#set -o vi
#bind '"":ed-clear-screen'
#alias cl="clear"

if -d ~/sbin; then
	source ~/sbin/cloud_profile
	source ~/sbin/javarc_profile
	source ~/sbin/git_profile
	source ~/sbin/rvm_profile
fi

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

