# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

case $- in
	*i*) ;;
  	*) return;;
esac

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# random stuff i need globally
export PATH="/usr/local/sbin:$PATH"
export effective_notes_init="$HOME/Sync/w/notes"
export mac_ip=$(ifconfig en9 | grep inet | awk '$1=="inet" {print $2}')

# Go
export GOPATH="$HOME/.go"
export PATH=$PATH:$GOPATH/bin
export GO111MODULE=on

# envm stuff
export envm="$HOME/.envm"
export envm_wdir="$HOME/Sync/w/fun"
export envm_auto_update_days=14
source $envm/init.sh

case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
		color_prompt=yes
  else
		color_prompt=
  fi
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

PS1='[\u@\h \W]\$ '

# get current branch in git repo
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "(${BRANCH}${STAT}) "
    else
        echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    modified=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${modified}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}

# Colored Shell Prompt with git status
export PS1="\[\e[1;32m\]\u\[\e[m\]::\[\e[1;31m\]\h\[\e[m\] \[\e[1;10m\]\W\[\e[m\]\\$ \[\e[1;36m\]\`parse_git_branch\`\[\e[m\]"

# Starting a new TMUX Session as soon as everything is loaded
tmux
