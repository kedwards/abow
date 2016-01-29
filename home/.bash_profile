<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
DRIVE=C
APP_DIR=/cygdrive/$drive/knc/app/PortableApps
=======
=======
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

>>>>>>> removed unused configurations
DRIVE=D
<<<<<<< HEAD
<<<<<<< HEAD
<<<<<<< HEAD
APP_DIR=/cygdrive/$DRIVE/knc/app/PortableApps
>>>>>>> removed vim plugins
=======
DRIVE=D
APP_DIR=/cygdrive/$DRIVE/knc/app/PortableApps
>>>>>>> removed vim plugins

if [ -r ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
fi
=======
>>>>>>> Adding GnuPG, Bash, and SSH configurations
=======
APP_DIR=/cygdrive/$DRIVE/knc/PortableApps
=======
APP_DIR=/cygdrive/$DRIVE/PortableApps
>>>>>>> fixed links to PortableApps
STOR=/cygdrive/$DRIVE/knc/stor
>>>>>>> Updates

if [ -f ~/.bashrc ]; then
 	. ~/.bashrc
fi

<<<<<<< HEAD
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

<<<<<<< HEAD
fi
=======
    fi
    ;;
<<<<<<< HEAD
 esac
>>>>>>> Adding GnuPG, Bash, and SSH configurations
=======
esac
>>>>>>> removed unused configurations
=======
export HOME=/cygdrive/$DRIVE/knc/nix/home

export VIRTUALBOX_PATH=$APP_DIR/virtualbox/app64
export VBOX_USER_HOME=$STOR/vm/machines


export VAGRANT_HOME=/knc/stor/.vagrant.d
#export VAGRANT_DOTFILE_PATH=/knc/stor/.vagrant.d
export VAGRANT_PATH=$APP_DIR/vagrant/bin

export PATH=$VAGRANT_PATH:$VIRTUALBOX_PATH:/usr/local/bin:/usr/bin

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
>>>>>>> Updates
