# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.

DRIVE=D
APP_DIR=/cygdrive/$DRIVE/PortableApps
STOR=/cygdrive/$DRIVE/knc/stor

if [ -f ~/.bashrc ]; then
 	. ~/.bashrc
fi

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
