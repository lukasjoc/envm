#!/usr/local/bin/bash

alias ..="cd ../"
alias ...="cd ../../"
alias ....="cd ../../../"
alias dc="docker-compose"
alias kctl="kubectl"
alias mkube="minikube"
alias pb="perlbrew"
alias pbl="perlbrew list"
alias br="brew"
alias bc="brew cask"
alias ls="ls -GF"
alias ll="ls -alF"
alias mkdir="mkdir -p"
alias rmdir="rm -rf"
alias dated="date +'%d.%m.%y'"
alias count="ls -l | grep "" -c"
alias watchdir="watch -d ls -halFG "
alias mr="mysql -uroot -p"
alias newshell="exec $SHELL -l"
alias npmls="npm list -g --depth=0"
alias fun="cd $envm_wdir"
alias prunegit="git branch --merged master --no-color | grep -v master | grep -v stable | xargs git branch -d"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls -F --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
