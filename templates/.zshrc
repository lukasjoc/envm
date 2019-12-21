# This is my setup for macosx systems
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
export PATH="/usr/local/bin:${PATH}"

# envm stuff
export envm="$HOME/.envm"
export envm_wdir="$HOME/Sync/"
export envm_auto_update_days=30
source $envm/envm.sh

# Editor
export EDITOR="vim"
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR="vim"
fi

# Go
export PATH=$PATH:$GOPATH/bin
export GOPATH="$HOME/go"
export GO111MODULE=on

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _complete
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|=* r:|=*'

autoload -U compinit && compinit
zmodload -i zsh/complist

unsetopt menu_complete
unsetopt flowcontrol

setopt prompt_subst
setopt always_to_end
setopt append_history
setopt auto_menu
setopt complete_in_word
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt interactivecomments
setopt share_history

PS1="%{%F{red}%}%n%{%f%}@%{%F{blue}%}%m %{%F{yellow}%}%~ %f%}% \$ "
