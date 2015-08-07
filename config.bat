::
:: KnC.bat configuration
::

:: Status
:: Installed, last Updated
set installed=1
set updated=2010-04-14

:: 
::32-bit (x86) or 64-bit (x86_64) architecture
set arch=x86_64

:: Package List
set packages=curl,git,screen,vim,vim-common,wget,gnupg

:: Auto-update Cygwin binary
set auto_update=0

:: Proxy ex. http://<user>:<password>@<proxy:port>
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
set linux_home=\/cygdrive\/%drive%\/knc\/%folder%\/home