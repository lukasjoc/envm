#!/bin/bash

alias ..="cd ../"
alias ...="cd ../../"

alias dc="docker-compose"
alias bc="brew cask"

alias ls="ls -GF"
alias sl="ls -GF"
alias ll="ls -hal"

alias mkdir="mkdir -p"
alias rmdir="rm -rf"

alias datef="date +'%d.%m.%y'"
alias count="ls -l | wc -l"
alias watchdir="watch -d ls -halFG "
alias mysqlroot="mysql -uroot"
alias ns="exec $SHELL -l"

alias pgit="git branch --merged master --no-color | grep -v master | grep -v stable | xargs git branch -d"
alias gp="git pull"
alias gits="git branch && echo && git status"

alias npmls="npm list -g --depth=0" # oh my fu**ing good I hate npm and node EcoS so much
alias fun="cd $envm_wdir"

alias python="python3" # this is overwriting the bullshit apple python
alias pytest="python3 -m pytest -v"
alias pip="pip3"

alias gobench="go test -v --bench . --benchmem"
alias goclean="go clean -x -r -cache -modcache"

alias speedtest="curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -"
alias ±="cd $HOME"
