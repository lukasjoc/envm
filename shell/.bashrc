# This is my setup for Linux systems, mainly for VPS's, & Vm's

HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

export PATH="/usr/local/bin:${PATH}"
export PS1='\[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \w\[\033[0;32m\] - [$(git branch 2>/dev/null | grep "^*" | colrm 1 2)\[\033[0;32m\]]\[\033[0m\033[0;32m\] \$\[\033[0m\033[0;32m\]\[\033[0m\] '

# Start up SSH session with tmux open
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

# Some Aliases
alias ..="cd ../"
alias dc="docker-compose"
alias ls="ls -F --color=auto"
alias ll="ls -alF"
alias go_tools="sh ~/go-tools.sh"
alias mkdir="mkdir -p"
alias rmdir="rm -rf"

alias cooldocker="printf '\n'; cimages && docker images && printf '\n'; ccontainer && docker container ls && printf '\n'; cnets && docker network ls"
alias cimages='printf 🐋=IMAGES\ CURRENTLY\ USED=🐋:" "; docker images | grep "" -c'
alias ccontainer='printf 🐋=CONTAINER\ CURRENTLY\ RUNNING=🐋:" "; docker container ls | grep "" -c'
alias cnets='printf 🐋=NETWORKD\ CURRENTY\ USED=🐋:" "; docker network ls | grep "" -c'

# Go
export GOPATH="$HOME/go"
export GO111MODULE=on #Module support on| turn it off for module usage in $GOPATH
export PATH=$PATH:$GOPATH/bin:PATH
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Python
eval "$(pyenv init -)"


# Setting working dir
if [ -d "$HOME/Sync/" ]; then
  cd $HOME/Sync/w/
elif [ -d "$HOME/w/" ]; then
  cd $HOME/w/
else
  print Please setup your working directory ether as $HOME/Sync/w or $HOME/w/!;
fi

if [ -d "$HOME/Sync/w" ] || [ -d "$HOME/w" ]; then
  print “Inspiration exists, but it has to find you working.” — Pablo Picasso;
fi
