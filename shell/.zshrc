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
source $ENVM/envm.sh
source $ENVM/scripts/startup.sh

# Editor
export EDITOR="vim"
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
fi

# Go
export GOPATH="$HOME/go"
export GO111MODULE=on #Module support on| turn it off for module usage in $GOPATH
export PATH=$PATH:$GOPATH/bin:PATH
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"
alias go_tools="sh ~/go-tools.sh"

# Python
eval "$(pyenv init -)"
if which pyenv-virtualenv-init > /dev/null; then 
  eval "$(pyenv virtualenv-init -)"; 
fi

# Perl5
source $HOME/perl5/perlbrew/etc/bashrc
