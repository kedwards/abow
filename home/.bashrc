# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-*color) color_prompt="yes";;
esac

# get current git branch name
function git_branch {
    export gitbranch=[$(git rev-parse --abbrev-ref HEAD 2>/dev/null)]
    if [ "$?" -ne 0 ]
      then gitbranch=
    fi
    if [[ "${gitbranch}" == "[]" ]]
      then gitbranch=
    fi
}

# set usercolor based on whether we are running with Admin privs
function user_color {
    id | grep "Admin" > /dev/null
    RETVAL=$?
    if [[ $RETVAL == 0 ]]; then
        usercolor="[1;32m";
    else
        usercolor="[1;31m";
    fi
}

# Set prompt colors
inputcolor='[0;37m'
cwdcolor='[1;32m'
gitcolor='[1;33m'
user_color

PROMPT_COMMAND='git_branch; history -a;'

if [ -z "$color_prompt" ]; then
    PS1='\[\033${usercolor}\]:[\u]:\[\033${gitcolor}\]:${gitbranch}:\[\033${cwdcolor}\]:[\w]:\[\033${inputcolor}\]: '
else
    PS1='[\u]::${gitbranch}::[\w]: '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias l='ls -laF --color=auto'
	alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi


# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Build tag files
ctags-php(){ ctags -f ~/.vim.tags/$1 -h ".php" --totals=yes --tag-relative=yes --fields=+aimSfkst --PHP-kinds=+cf -R $2; }

# proxy on/off
prox()
{
	if [ "$1" == "on" ]; then
		PROXY=http://localhost:3128;
		ACTION=start;
	elif [ "$1" == "off" ]; then
		PROXY="";
		ACTION=stop;
	fi
	
	if [ $ACTION ]; then
		export http_proxy=$PROXY;
		export HTTP_PROXY=$PROXY;
		export https_proxy=$PROXY;
        export ftp_proxy=$PROXY;
		
		if [ "$ACTION" == "start" ]; then
			sed -i 's|#proxy = http://localhost:3128|proxy = http://localhost:3128|' ~/.curlrc ~/.gitconfig
             cygstart /cygdrive/d/knc/PortableApps/cntlm/cntlm.exe -vc /cygdrive/d/knc/PortableApps/cntlm/cntlm.ini
		else
			sed -i 's|proxy = http://localhost:3128|#proxy = http://localhost:3128|' ~/.curlrc ~/.gitconfig
            cygstart tskill cntlm
		fi
	fi
}

# aria2 on/off
aria2()
{
    if [ "$1" == "on" ]; then
		cygstart /cygdrive/d/knc/PortableApps/aria2/aria2c.exe --enable-rpc --rpc-listen-all
	elif [ "$1" == "off" ]; then
		cygstart tskill aria2c
	fi
}