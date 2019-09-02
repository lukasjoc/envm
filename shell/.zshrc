# This is my setup for macosx systems

HISTSIZE=1000
HISTFILESIZE=2000
export PATH="/usr/local/bin:${PATH}"

# Good ozsh stuff
export ZSH="$HOME/.oh-my-zsh"
export UPDATE_ZSH_DAYS=7
ZSH_THEME="gentoo"
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

#Some Aliases
alias ..="cd ../"
alias dc="docker-compose"
alias bc="brew cask"
alias ls="rm -rf .DS_Store && ls -GF" #Fuck You .DSSTORE
alias ll="rm -rf .DS_Store && ls -alF" #Fuck You .DSSTORE
alias rmd="rm -rf"
alias go_tools="sh ~/go-tools.sh"

# Set working environment
cd $HOME/w/
echo " “Inspiration exists, but it has to find you working.” — Pablo Picasso"
