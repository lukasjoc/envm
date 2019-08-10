ZSH_THEME="gentoo"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS=true
CASE_SENSITIVE=false
plugins=(git)

#export PATH=$HOME/bin:/usr/bin:$PATH
export PATH="/usr/local/bin:${PATH}"
export ZSH="/Users/lj/.oh-my-zsh"
export UPDATE_ZSH_DAYS=29


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
alias ll="ls -la"

# Go
export GOPATH="$HOME/go"
export GO111MODULE=on
export PATH=$PATH:$GOPATH/bin:PATH

# Go Version Manager
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Set working environment
cd ~/w/ && tmux
