# This is my setup for macosx systems

HISTFILE=$HOME/.zsh_history
HISTSIZE=100000
SAVEHIST=$HIST

export PATH="/usr/local/bin:${PATH}"

autoload -Uz compinit;
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

zmodload -i zsh/complist
setopt hist_ignore_all_dups # remove older duplicate entries from history
setopt hist_reduce_blanks # remove superfluous blanks from history items
setopt inc_append_history # save history entries as soon as they are entered
setopt share_history # share history between different instances of the shell
setopt auto_cd # cd by typing directory name if it's not a command
setopt correct_all # autocorrect commands
setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion


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




PS1="%{%F{red}%}%n%{%f%}@%{%F{blue}%}%m %{%F{yellow}%}%~ %f%}% \$ "
