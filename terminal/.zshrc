ZSH_THEME="gentoo"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS=true
CASE_SENSITIVE=false

export PATH="/usr/local/bin:${PATH}"
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=7
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nano'
fi

# Go
export GOPATH="$HOME/go"
export GO111MODULE=on #Module support on
export PATH=$PATH:$GOPATH/bin:PATH
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Python
eval "$(pyenv init -)"

#Some Aliases
alias ..="cd ../"
alias dc="docker-compose"
alias bc="brew cask"
alias ls="ls -GF"
alias ll="ls -GalF"
alias rmd="rm -rf"

# Set Synced working environment
cd ~/Sync/w/
