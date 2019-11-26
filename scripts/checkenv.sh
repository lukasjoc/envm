#!/bin/sh

#Name: checkenv.sh
#Author: lukasjoc, 2019 (https://lukasjoc.com)
#Desc: Checks, configures development path, and working dir
#===================================================

pathchecker() {
	if [ -d "$HOME/Sync/w" ] || [ -d "$HOME/w" ]; then
  	if hash figlet 2>/dev/null; then
    	figlet "Hello, $USER"
      tmuxinator default
    else
      echo "Hello, $USER"
      tmuxinator default
    fi
    echo '“Inspiration exists, but it has to find you working.” — Pablo Picasso'
  else
    echo "I Think your working path is not set correctly"
  fi
}

echo "Checking ENVironment for $USER..."
pathchecker
