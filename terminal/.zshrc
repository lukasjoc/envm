export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="/Users/lj/.oh-my-zsh"
export UPDATE_ZSH_DAYS=28

ZSH_THEME="gentoo"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS=true
plugins=(git)

source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nano'
fi

alias ..="cd ../"
alias d="docker"
alias dc="docker-compose"
alias br="brew"
alias bc="brew cask"
alias ll="ls -lisaG"
alias ls='ls -G'

# Go
export GOPATH="$HOME/go"
export GO111MODULE=on
export PATH=$PATH:$GOPATH/bin:PATH

# Wdir
cd ~/fun
