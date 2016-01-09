# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

DRIVE=D

if [ -f ~/.bashrc ]; then
 	. ~/.bashrc
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
xterm-256color)
    export HOME=/cygdrive/$DRIVE/knc/nix/home

    # composer
    export COMPOSER_HOME=~/.composer

    PATH=$PHP_PATH:$VAGRANT_PATH:$PATH

    USCREEN=/tmp/uscreens
    UUSCREEN=/tmp/uscreens/S-$USERNAME

    if [ -d $USCREEN ]; then
        chmod 777 $USCREEN
        chgrp Users $USCREEN
        chmod 700 $UUSCREEN
        echo "Starting screen in 3 seconds, press Q to cancel.";  
        for i in 3 2 1 ; do   
            read -n 1 -t 1 -s a && break  
        done  
        set a = $a | tr '[A-Z]' '[a-z]'  
        if [ "$a" != "q" ]; then
            if [ ${SHLVL} -eq 1 ]; then
                ((SHLVL+=1)); export SHLVL
                exec screen -ln -R -e "^Ee" ${SHELL}
            fi
        fi

    fi
    ;;
esac
