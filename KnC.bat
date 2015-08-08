@echo off
set local

:: 
:: knc-linux
::
:: Copyright (c) 2008 - 2015 K&C Edwards Consulting Ltd.
:: All rights reserved.
::
:: Redistribution and use in source and binary forms, with or without
:: modification, are permitted provided that the following conditions
:: are met:
::
:: - Redistributions of source code must retain the above copyright
:: notice, this list of conditions and the following disclaimer.
::
:: - Redistributions in binary form must reproduce the above
:: copyright notice, this list of conditions and the following
:: disclaimer in the documentation and/or other materials provided
:: with the distribution.
::
:: THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
:: "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
:: LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
:: FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
:: COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
:: INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
:: BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
:: LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
:: CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
:: LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
:: ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
:: POSSIBILITY OF SUCH DAMAGE.
::
goto :MAIN

if "%selfWrapped%"=="" (
  :: This is necessary so that we can use "exit" to terminate the batch file,
  :: and all subroutines, but not the original cmd.exe
  set selfWrapped=true
  %ComSpec% /s /c ""%~0" %*"
  goto :EOF
)

:CHECK_BIN
	echo %prefix% Veriyfing required binaries are available..
	:: Check for required binary to download setup-%arch%.exe
	:: Prefer curl over wget from knc-linux over system path location
	if exist %bindir%\curl.exe set exe=curl.exe
	if exist %bindir%\curl.exe exit /b 0
	for /f %%i in ("curl.exe") do if not "%%~$PATH:i" == "" set exe=curl.exe
	for /f %%i in ("curl.exe") do if not "%%~$PATH:i" == "" exit /b 0
	if exist %bindir%\wget.exe set exe=wget.exe
	if exist %bindir%\wget.exe exit /b 0
	for /f %%i in ("wget.exe") do if not "%%~$PATH:i" == "" set exe=wget.exe
	for /f %%i in ("wget.exe") do if not "%%~$PATH:i" == "" exit /b 0
	echo.
	echo %prefix% ERROR: Unable to locate one of the required binaries (Curl / Wget)
	echo.
	echo  %prefix% The required binaries can be downloaded from:
	echo    %prefix% Curl: http://curl.haxx.se/
	echo    %prefix% Wget: http://users.ugent.be/~bpuype/wget/
exit /b 1

:CONFIG
    echo KnC Linux Config
	echo ================
	echo Arch:        %arch%
    echo Packges:     %packages%
    echo Auto Update: %auto_update%
    echo Proxy:       %proxy%
    echo Installed:   %installed%
    echo Ports Dir:   %portsdir%
    echo Pubkey Site: %pubkeysite%
    echo Mirror Site: %site%
    echo Drive:       %drive%
    echo KnC Root:    %kncroot%
    echo Root Dir:    %rootdir%
    echo Home:        %home%
    echo Local Dir:   %localdir%
exit /b 0

:GET_SETUP
	echo %prefix% Retrieving setup..
	:: Download latest setup-%arch%.exe
	if not exist %rootdir% mkdir %rootdir%
    if not exist %rootdir%\cygwin.exe echo %prefix% ERROR: %rootdir%\cygwin.exe cannot be found. && exit /b 1
	
    if defined proxy set HTTP_PROXY=%proxy%
	if defined proxy set HTTPS_PROXY=%proxy%
    
	if "%auto_update% == "1" echo %prefix% INFO: Downloading new setup..
	if "%auto_update% == "1" if /I "%exe%"=="curl.exe" %bindir%\%exe% -so %rootdir%\cygwin.exe http://cygwin.com/setup-%arch%.exe
	if "%auto_update% == "1" if /I "%exe%"=="wget.exe" %bindir%\%exe% -qO %rootdir%\cygwin.exe http://cygwin.com/setup-%arch%.exe%
exit /b 0

:HANDLE_ERROR
	echo.
	echo Please correct the errors above and rerun the script.
	exit /b 1
	goto :EOF

:INIT
	echo %prefix% Initializing system, please wait..
	set conffile=%~dp0config.bat
	if not exist %conffile% echo ERROR: Configuration file %conffile% not found. && exit /b 1
	call %conffile%
	if "%packages%"=="" echo %prefix% ERROR: No packages have been defined in %conffile% && exit /b 1
	if "%rootdir%"=="" echo %prefix% ERROR: No rootdir has been defined in %conffile% && exit /b 1
	if "%site%"=="" echo %prefix% ERROR: mirror site has not been defined in %conffile% && exit /b 1
exit /b 0

:INSTALL_UPDATE
	echo %prefix% Running Setup-%arch%.exe to install/upgrade packages
	call :CHECK_BIN || exit /b 1
	call :GET_SETUP || exit /b 1

	::Command Line Options:
	:: -D --download                     Download from internet
	:: -L --local-install                Install from local directory
	:: -s --site                         Download site
	:: -O --only-site                    Ignore all sites except for -s
	:: -R --root                         Root installation directory
	:: -x --remove-packages              Specify packages to uninstall
	:: -c --remove-categories            Specify categories to uninstall
	:: -P --packages                     Specify packages to install
	:: -C --categories                   Specify entire categories to install
	:: -p --proxy                        HTTP/FTP proxy (host:port)
	:: -a --arch                         architecture to install (x86_64 or x86)
	:: -q --quiet-mode                   Unattended setup mode
	:: -M --package-manager              Semi-attended chooser-only mode
	:: -B --no-admin                     Do not check for and enforce running as Administrator
	:: -h --help                         print help
	:: -l --local-package-dir            Local package directory
	:: -r --no-replaceonreboot           Disable replacing in-use files on next reboot.
	:: -X --no-verify                    Don't verify setup.ini signatures
	:: -n --no-shortcuts                 Disable creation of desktop and start menu shortcuts
	:: -N --no-startmenu                 Disable creation of start menu shortcut
	:: -d --no-desktop                   Disable creation of desktop shortcut
	:: -K --pubkey                       URL of extra public key file (gpg format)
	:: -S --sexpr-pubkey                 Extra public key in s-expr format
	:: -u --untrusted-keys               Use untrusted keys from last-extrakeys
	:: -U --keep-untrusted-keys          Use untrusted keys and retain all
	:: -g --upgrade-also                 also upgrade installed packages
	:: -o --delete-orphans               remove orphaned packages
	:: -A --disable-buggy-antivirus      Disable known or suspected buggy anti virus software packages during execution.
	::
	if "%proxy%" == ""  %rootdir%\cygwin.exe --quiet-mode --no-shortcuts --upgrade-also --arch %arch% --site %site% --root %rootdir% --local-package-dir %localdir% --packages %packages%
	if "%proxy%" neq "" %rootdir%\cygwin.exe --quiet-mode --no-shortcuts --upgrade-also --arch %arch% --site %site% --root %rootdir% --local-package-dir %localdir% --packages %packages% --proxy %proxy%
	if "%installed%" == "0" %rootdir%\bin\sed.exe -i -r -e 's/^set installed=0$/set installed=1/' %kncroot%/config.bat
	%rootdir%\bin\sed.exe -i -r -e 's/^set updated=.*$/set updated=%date%/' %kncroot%/config.bat
exit /b 0

:PERMISSIONS
	echo %prefix% INFO: Fixing permissions, this may take some time..
	set /p continue=Do you wish to continue (Y/N)?
	if /i "%continue:~,1%" equ "Y" goto ::FIXUP
	if /i "%continue:~,1%" equ "N" echo Fixing permissions terminated && exit /b 1
	echo %prefix% ERROR: Please type Y for Yes or N for No..
	:FIXUP
	takeown /f %home% /r /d y 
	takeown /f %rootdir% /r /d y 
	icacls %home% /grant %username%:F /t /q 
	icacls %rootdir% /grant %username%:F /t /q 
exit /b 0

:RUN
	findstr /m /i /c:"DRIVE=%drive%" %home%\.bash_profile > nul
	if "%errorlevel%"=="1" %rootdir%\bin\sed.exe -i -r -e 's/^DRIVE=.*$/DRIVE=%drive%/' %home%/.bash_profile
	
	findstr /m /i /c:"DRIVE=%drive%" %home%\.bash_aliases > nul
	if "%errorlevel%"=="1" %rootdir%\bin\sed.exe -i -r -e 's/^DRIVE=.*$/DRIVE=%drive%/' %home%/.bash_aliases
	
	%rootdir%\bin\mkgroup.exe -l > %rootdir%\etc\group
	%rootdir%\bin\mkpasswd.exe -l > %rootdir%\etc\passwd
	%rootdir%\bin\mkpasswd.exe -c >> %rootdir%\etc\passwd
    
	findstr /m /c:"%linux_home%" %rootdir%\etc\passwd > nul
	if "%errorlevel%"=="1" %rootdir%\bin\sed.exe -i -r -e 's/\/home\/%username%/%linux_home%/' %rootdir%\etc\passwd
	
	:: bash with mintty frontend
	:: Options:
	::  -c, --config FILE     Load specified config file
	::  -e, --exec            Treat remaining arguments as the command to execute
	::  -h, --hold never|start|error|always  Keep window open after command finishes
	::  -i, --icon FILE[,IX]  Load window icon from file, optionally with index
	::  -l, --log FILE|-      Log output to file or stdout
	::  -o, --option OPT=VAL  Override config file option with given value
	::  -p, --position X,Y    Open window at specified coordinates
	::  -s, --size COLS,ROWS  Set screen size in characters
	::  -t, --title TITLE     Set window title (default: the invoked command)
	::  -u, --utmp            Create a utmp entry
	::  -w, --window normal|min|max|full|hide  Set initial window state
	::      --class CLASS     Set window class name (default: mintty)
	::  -H, --help            Display help and exit
	::  -V, --version         Print version information and exit
	start %rootdir%\bin\mintty.exe -t "KnC Linux on Windows" -s 100,30 -i %rootdir%\Cygwin-Terminal.ico -e /bin/bash --login -i
exit

:UNINSTALL
	echo %prefix% WARNING: Uninstalling KnC-Linux..
	set /p continue=Do you wish to remove KnC-Linux (Y/N)?
	if /i "%continue:~,1%" equ "Y" goto :CLEANUP
	if /i "%continue:~,1%" equ "N" echo Uninstall terminated && exit /b 1
	echo %prefix% ERROR: Please type Y for Yes or N for No..
	goto :UNINSTALL
	:CLEANUP
	if exist %rootdir% rmdir /S /Q %rootdir%
    if exist %localdir% rmdir /S /Q %localdir%
    echo %prefix% INFO: Cleaning up Completed
exit /b 0

:GET_ADMIN
    :: ADMIN CMD - %windir%\System32\cmd.exe /k "cd /d c:\knc\nix"
	:: Check for ADMIN privileges, https://sites.google.com/site/eneerge/home/BatchGotAdmin
    >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
    if '%errorlevel%' neq '0' (
        echo Requesting administrative privileges...
        goto UACPrompt
    ) else (goto :GOT_ADMIN)
    :UACPrompt
        echo Set UAC = CreateObject^("Shell.Application"^) > getadmin.vbs
        echo UAC.ShellExecute "%~s0", "%1", "", "runas", 1 >> getadmin.vbs
        getadmin.vbs && del getadmin.vbs
        exit /b 0
    :GOT_ADMIN
exit /b 0

:: -- MAIN --
:MAIN
	cls
	call :GET_ADMIN
	pause
	call :INIT || goto :HANDLE_ERROR
	for %%a in (%*) do (if "%%a"=="c" call :CONFIG)
	for %%a in (%*) do (if "%%a"=="u" call :INSTALL_UPDATE || goto :HANDLE_ERROR)
    for %%a in (%*) do (if "%%a"=="r" call :REMOVE || goto :HANDLE_ERROR)
    for %%a in (%*) do (if "%%a"=="p" call :PERMISSIONS || goto :HANDLE_ERROR)
	if "%1"=="" call :RUN || goto :HANDLE_ERROR
exit /b 0