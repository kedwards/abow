DRIVE=D
APP_DIR=/cygdrive/$DRIVE/knc/app/PortableApps

if [ -r ~/.dircolors ]; then
    eval "$(dircolors ~/.dircolors)"
fi

if [ -f ~/.bashrc ]; then
 	. ~/.bashrc
fi

COMPOSER_HOME=/cygdrive/$DRIVE/knc/nix/home/.composer
HOME=/cygdrive/$DRIVE/knc/nix/home
OPENSSL_CONF=~/.ssl/openssl.cnf
PHP_PATH=$APP_DIR/easy-php/binaries/php/php_runningversion
TERM=xterm-256color
VAGRANT_HOME=~/.vagrant
VAGRANT_PATH=$APP_DIR/vagrant/bin
VIRTUALBOX_PATH=$APP_DIR/virtualbox/app64

PATH=$PHP_PATH:$VAGRANT_PATH:$VIRTUALBOX_PATH:$PATH
export TERM PATH OPENSSL_CONF HOME VAGRANT_HOME COMPOSER_HOME

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