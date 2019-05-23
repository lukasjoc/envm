# Start up SSH session with tmux open
if [[ -z "$TMUX" ]] && [ "$SSH_CONNECTION" != "" ]; then
    tmux attach-session -t ssh_tmux || tmux new-session -s ssh_tmux
fi

# get current branch in git repo
function parse_git_branch() {
    BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
    if [ ! "${BRANCH}" == "" ]
    then
        STAT=`parse_git_dirty`
        echo "(${BRANCH}${STAT}) "
    else
        echo ""
    fi
}

# get current status of git repo
function parse_git_dirty {
    status=`git status 2>&1 | tee`
    modified=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
    untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
    ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
    newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
    renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
    deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
    bits=''
    if [ "${renamed}" == "0" ]; then
        bits=">${bits}"
    fi
    if [ "${ahead}" == "0" ]; then
        bits="*${bits}"
    fi
    if [ "${newfile}" == "0" ]; then
        bits="+${bits}"
    fi
    if [ "${untracked}" == "0" ]; then
        bits="?${bits}"
    fi
    if [ "${deleted}" == "0" ]; then
        bits="x${bits}"
    fi
    if [ "${modified}" == "0" ]; then
        bits="!${bits}"
    fi
    if [ ! "${bits}" == "" ]; then
        echo " ${bits}"
    else
        echo ""
    fi
}

# DOCKER,DOCKER-COMPOSE
alias do="docker"
alias dc="docker-compose"
alias dcon="do container"

#SYSTEM Stuff
alias ip="ip addr"
alias rm="rm -rf"

alias ll="ls -lhaG"
alias l="ls -lhaG"
alias ls="ls -lhG"

alias ..="cd ../"
alias ...="cd ../../../"

# HOMEBREW
alias br="brew"
alias bc="brew cask"

#NEOVIM 
alias vim="nvim"
alias vi="nvim"

# PSQL ADMIN
alias psql_up="launchctl load ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"
alias psql_newusr="createuser --interactive --pwprompt" 
alias psql_stop="launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.postgresql.plist"

#GOPATH
export GOPATH="$HOME/go"
export GO111MODULE=on #use go modules inside the $GOPATH
export PATH=$PATH:$GOPATH/bin
