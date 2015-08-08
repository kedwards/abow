DRIVE=C

alias home='cd /cygdrive/$DRIVE/knc/nix/home'
alias gip="cygcheck -c -d|sed -e "1,2d" -e 's/ .*$//' > ~/installedPackages"
alias lf='ls -AlF --color'
alias ls='ls --color'
alias lt='ls -AlFhtr --color'
alias vi='vim'