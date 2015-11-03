# Return immediately if we are not interactive
[ -z "$PS1" ] && return

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

# Set prompt and window title
inputcolor='[0;37m'
cwdcolor='[1;32m'
gitcolor='[1;33m'
user_color

PROMPT_COMMAND='git_branch; history -a;'

PS1='\[\033${usercolor}\]:[\u]:\[\033${gitcolor}\]:${gitbranch}:\[\033${cwdcolor}\]:[\w]:\[\033${inputcolor}\] '
export PS1

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
             cygstart /cygdrive/d/knc/app/PortableApps/cntlm/cntlm.exe -vc /cygdrive/d/knc/app/PortableApps/cntlm/cntlm.ini
		else
			sed -i 's|proxy = http://localhost:3128|#proxy = http://localhost:3128|' ~/.curlrc ~/.gitconfig
            tskill cntlm
		fi
	fi
}