DRIVE=D

alias app='cd /cygdrive/$DRIVE/PortableApps'
alias dev='cd /cygdrive/$DRIVE/knc/stor/dev'
alias dl='cd /cygdrive/$DRIVE/knc/dl'
alias gip="cygcheck -c -d|sed -e "1,2d" -e 's/ .*$//' > ~/installedPackages"
alias nix='cd /cygdrive/$DRIVE/knc/nix'
alias root='cd /cygdrive/$DRIVE/knc'
alias stor='cd /cygdrive/$DRIVE/knc/stor'
alias vi='vim'
alias update='cygstart.exe /cygdrive/d/knc/nix/KnC.bat u'
