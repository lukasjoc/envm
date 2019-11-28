# This is my setup for macosx systems

HISTSIZE=1000
HISTFILESIZE=2000
export PATH="/usr/local/bin:${PATH}"

# Good ozsh stuff
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=7000
ZSH_THEME="gianu"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS=true
CASE_SENSITIVE=false
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nano'
fi

# Go
export GOPATH="$HOME/go"
export GO111MODULE=on #Module support on| turn it off for module usage in $GOPATH
export PATH=$PATH:$GOPATH/bin:PATH
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Python
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then 
  eval "$(pyenv virtualenv-init -)"; 
fi

# Perl
source $HOME/perl5/perlbrew/etc/bashrc
alias pb="perlbrew"
alias pbl="perlbrew list"

#Some Aliases
alias ..="cd ../"
alias dc="docker-compose"
alias bc="brew cask"
alias ls="ls -GF"
alias ll="ls -alF"
alias mkdir="mkdir -p"
alias rmdir="rm -rf"
alias cooldocker="printf '\n'; cimages && docker images && printf '\n'; ccontainer && docker container ls && printf '\n'; cnets && docker network ls"
alias cimages='printf 🐋=IMAGES\ CURRENTLY\ USED=🐋:" "; docker images | grep "" -c'
alias ccontainer='printf 🐋=CONTAINER\ CURRENTLY\ RUNNING=🐋:" "; docker container ls | grep "" -c'
alias cnets='printf 🐋=NETWORKD\ CURRENTY\ USED=🐋:" "; docker network ls | grep "" -c'
alias count='ls -l | grep "" -c'
# Setting working dir
if [ -d "$HOME/Sync/" ]; then
  cd $HOME/Sync/w/
  alias work="cd $HOME/Sync/w/"
  alias fun="cd $HOME/Sync/w/fun/"
elif [ -d "$HOME/w/" ]; then
  cd $HOME/w/
  alias work="cd $HOME/w/"
  alias fun="cd $HOME/w/fun/"
else
  print Please setup your working directory ether as $HOME/Sync/w or $HOME/w/!;
fi

# Greeting on terminal start
if [ -d "$HOME/Sync/w" ] || [ -d "$HOME/w" ]; then
  if hash figlet 2>/dev/null; then
    figlet "Hello, $USER"
  else
    print Hello, $USER
  fi
  print “Inspiration exists, but it has to find you working.” — Pablo Picasso;
else
  print I Think your working path is not set correctly
fi
