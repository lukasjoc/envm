# $HOME/.zshrc

HISTSIZE=1000
HISTFILESIZE=2000

export PATH="/usr/local/bin:${PATH}"
export EDITOR='vim'

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

