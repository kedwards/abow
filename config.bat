::
:: KnC.bat configuration
::

:: Status
:: Installed, last Updated
set installed=1

:: 
::32-bit (x86) or 64-bit (x86_64) architecture
set arch=x86_64

:: Package List
<<<<<<< HEAD
<<<<<<< HEAD
set python_packages=python,python-crypto,python-paramiko,python-setuptools,python-ssl
=======
>>>>>>> Adding initial configuration file back to repo
set packages=curl,gcc,gcc-core,gnupg,git,make,openssh,openssl-devel,screen,vim,vim-common,wget
=======
set awscli_packages=binutils,libuuid,libuuid-devel,libssh2-devel,libssh2_1
set python_packages=python-crypto,python-paramiko,python-setuptools,python-ssl
set core_packages=curl,gcc,gcc-core,gnupg,git,make,openssh,openssl-devel,python,screen,vim,vim-common,wget
set packages=%core_packages%,%awscli_packages%
>>>>>>> Adding GnuPG, Bash, and SSH configurations

:: Auto-update Cygwin binary
set autoupdate=0

<<<<<<< HEAD
:: Proxy ex. http://<user>:<password>@<proxy:port>
<<<<<<< HEAD
:: http://kxedward:Chelsea!sMyLif3@calproxyusr.na.tlm.com:8080
=======
>>>>>>> Adding initial configuration file back to repo
:: cntlm http://localhost:3128
=======
:: Proxy
:: ex. http://<user>:<password>@<proxy:port>
:: ex. cntlm http://localhost:3128
>>>>>>> Adding GnuPG, Bash, and SSH configurations
set proxy=

:: Mirror & Cygwin Ports site
set portsdir=ftp://ftp.cygwinports.org/pub/cygwinports
set pubkeysite=http://cygwinports.org/ports.gpg
set site=http://cygwin.osuosl.org

:: Drive, root, package, and home directories
set drive=%~d0
set drive=%drive:~0,1%
set root=%~dp0
set rootdir=%root%cygwin-%arch%
set bindir=%root%bin
set home=%root%home
set localdir=%root%packages

for %%a in (.) do set folder=%%~na
<<<<<<< HEAD
set linux_home=\/cygdrive\/%drive%\/knc\/%folder%\/home
=======
set linux_home=\/cygdrive\/%drive%\/knc\/%folder%\/home
>>>>>>> Adding initial configuration file back to repo
