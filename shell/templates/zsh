# $HOME/.zshrc

HISTSIZE=1000
HISTFILESIZE=2000
export PATH="/usr/local/bin:${PATH}"
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=70000
ZSH_THEME="gianu"
DISABLE_UPDATE_PROMPT="true"
DISABLE_MAGIC_FUNCTIONS=true
CASE_SENSITIVE=false
source $ZSH/oh-my-zsh.sh

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

