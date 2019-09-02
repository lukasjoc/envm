# This is my setup for macosx systems

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
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
     test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
     alias ls='ls -G'
fi

# Not Recomded
# if [ -f ~/.bash_aliases ]; then
#      . ~/.bash_aliases
# fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi


HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize


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
alias ls="rm -rf .DS_Store && ls -F" #Fuck You .DSSTORE
alias ll="rm -rf .DS_Store && ls -alF" #Fuck You .DSSTORE
alias rmd="rm -rf"

# Set synced working environment
cd $HOME/Sync/w/
