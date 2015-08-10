DRIVE=D

alias dev='cd /cygdrive/$DRIVE/knc/stor/dev'
alias dl='cd /cygdrive/$DRIVE/knc/stor/dl'
alias root='cd /cygdrive/$DRIVE/knc'

alias gip="cygcheck -c -d|sed -e "1,2d" -e 's/ .*$//' > ~/installedPackages"
alias lf='ls -AlF --color'
alias ls='ls --color'
alias lt='ls -AlFhtr --color'
alias vi='vim'