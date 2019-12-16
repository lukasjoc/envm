# This is my setup for macosx systems

HISTSIZE=1000
HISTFILESIZE=2000
export PATH="/usr/local/bin:${PATH}"
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gianu"
# export UPDATE_ZSH_DAYS=7000
DISABLE_UPDATE_PROMPT="true"
DISABLE_AUTO_UPDATE="true" 
DISABLE_MAGIC_FUNCTIONS=true
CASE_SENSITIVE=false
source $ZSH/oh-my-zsh.sh

# ENVM Stuff
export ENVM="$HOME/.envm"
export ENVM_WDIR="$HOME/Sync/"
ENABLE_ENVM_AUTO_UPDATE="true"
source $ENVM/envm.sh


# Editor
export EDITOR="vim"
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
fi

# Go
export PATH=$PATH:$GOPATH/bin:PATH
export GOPATH="$HOME/go"
export GO111MODULE=on
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

# Python
eval "$(pyenv init -)"
if tooltest pyenv-virtualenv-init; then
  eval "$(pyenv virtualenv-init -)"; 
fi

# Perl5
source $HOME/perl5/perlbrew/etc/bashrc