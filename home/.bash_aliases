DRIVE=D

alias app='cd /cygdrive/$DRIVE/knc/app/PortableApps'
alias dev='cd /cygdrive/$DRIVE/knc/stor/dev'
alias dl='cd /cygdrive/$DRIVE/knc/dl'
alias nix='cd /cygdrive/$DRIVE/knc/nix'
alias root='cd /cygdrive/$DRIVE/knc'
alias gip="cygcheck -c -d|sed -e "1,2d" -e 's/ .*$//' > ~/installedPackages"
alias l='ls -laF --color'
alias vi='vim'