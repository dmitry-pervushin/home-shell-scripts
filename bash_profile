# export CVSROOT=:pserver:dimka@pervushin.msk.ru:/home/cvsroot/
alias grep="grep -nH --colour"

complete -cf sudo

export HOMEBREW=/opt/homebrew
export PATH=/usr/local/bin:$HOME/bin:$PATH:/sbin:/usr/sbin:/usr/java/jdk1.5.0_20/bin:$HOMEBREW/bin:$HOMEBREW/sbin

[ -d "$HOME/P/nvidia/mobile-nvs" ] && export PATH="$PATH:$HOME/P/nvidia/mobile-nvs"
[ -d "$HOME/.poetry/bin" ] && export PATH="$PATH:$HOME/.poetry/bin"

if [ ! -z $TERM -a ! $TERM = "dumb" ]; then
	. prj setup	

	# do customization depending on host name
	ME=`hostname`
	echo -n "## Configuring for $ME..."
	if [ -f ~/hosts/$ME ]; then
		echo "OK"
		. ~/hosts/$ME
	else
		echo "using defaults, done"
	fi
fi

alias hd='od -Ax -tx1z -v'
alias please='sudo'
alias colossus='python3 -m colossus '

export GIT_AUTHOR_NAME="dmitry pervushin"
export GIT_AUTHOR_EMAIL="dpervushin@gmail.com"
export GIT_COMMITTER_NAME="dmitry pervushin"
export GIT_COMMITTER_EMAIL="dpervushin@gmail.com"

export BASH_SILENCE_DEPRECATION_WARNING=1
export PS1='\[\033[1;32m\](\h)\[\033[1;36m\]:\[\033[1;31m\]\w\[\033[0m\] \$ '

[ -r "$HOME/P/nvidia/.extra_bashrc" ] && . "$HOME/P/nvidia/.extra_bashrc"


# >>> Codex installer >>>
export PATH="/Users/dimka/.local/bin:$PATH"
# <<< Codex installer <<<
