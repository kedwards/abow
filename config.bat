::
:: KnC.bat configuration
::

:: 
::32-bit (x86) or 64-bit (x86_64) architecture
set arch=x86_64

:: Package List
set packages=curl,git,screen,vim,vim-common,wget,gnupg

:: Auto-update Cygwin binary
set auto_update=0

:: Proxy ex. http://<user>:<password>@<proxy:port>
set proxy=

:: Status
:: Installed
:: last Updated
set installed=1
set updated=2015-08-04

:: Mirror & Cygwin Ports site
set portsdir=ftp://ftp.cygwinports.org/pub/cygwinports
set pubkeysite=http://cygwinports.org/ports.gpg
set site=http://cygwin.osuosl.org

:: Drive, root, package, and home directories
set drive=%~d0
set drive=%drive:~0,1%
set kncroot=%~dp0
set rootdir=%kncroot%cygwin-%arch%
set bindir=%kncroot%bin
set home=%kncroot%home
set localdir=%kncroot%packages

for %%a in (.) do set folder=%%~na
set linux_home=\/cygdrive\/%drive%\/%folder%\/home