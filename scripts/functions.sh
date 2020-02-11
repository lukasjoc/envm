#!/bin/bash

runbrewstuff() {
  echo "🍺 Running brew update..."
  brew update
  echo "🍺 Running brew upgrade..."
  brew upgrade
  echo "🍺  Running brew cask upgrade..."
  brew cask upgrade
  echo "🍻 Running brew cleanup..."
  brew cleanup && brew doctor
  echo "Done ;)"
}

makeglobal() { 
  if [ $# -eq 0 ]; then
    printf "%s\n" "Usage: makeglobal <current_name_with_extension> <target_name_without_extension>"
    return
  fi
  chmod +x $1
  cp $1 $2
  mv $2 "/usr/local/bin"
}

cooldocker() {
  printf "%s\n" "🐳 IMAGES: $(docker images -aq | wc -l)"
  docker images -a --digests && echo
  printf "%s\n" "🐳 CONTAINER: $(docker container ls -aq | wc -l)"
  docker container ls -a && echo
  printf "%s\n" "🐳 NETS: $(docker network ls -q | wc -l)"  
  docker network ls && echo
  printf "%s\n" "🐳 VOLUMES: $(docker volume ls -q | wc -l)" 
  docker volume ls && echo
}

killdocker() {
  docker stop $(docker container ls -aq)
  docker rm $(docker container ls -aq)
  docker volume prune -f
  docker network prune -f
  docker rmi $(docker images -aq)
}

tooltest() {
  if ! command -v $1 >/dev/null 2>&1; then
    echo "$1 is not installed :( "
    return
  fi
}

# just submit pre-tested solutions to exercism
# !!CAUTION: TESTING IS STILL ON YOU
exercism_submit() {
  if [ $# -eq 0 ]; then
    printf "%s\n" "Usage: exercism_submit <solution_file>"
    return
  fi
  if ! command -v exercism >/dev/null 2>&1; then
    echo "Exercism is not installed... "
    return
  fi
  exercism submit $1
}

# rename tmux window given the pane and new name 
# $1 pane(1,2,3..), $2 name("test","test1"...)
mv_tmux() {
  if [ $# -eq 0 ]; then
    printf "%s\n" "Usage: mv_tmux <pane_number> <pane_name>"
    return
  fi
  tmux rename-window -t $1 $2
}

# Return the AVG PingTime in your current network for pinging a high frequented server at google 
# or taking an URL as argument
function pingtime(){
  if [ $# -eq 0 ]; then
    return ping -c 4 www.google.com | tail -1| awk '{print $4}' | cut -d '/' -f 2
  else
    return ping -c $1 | tail -1 | awk '{print $4}' | cut -d '/' -f 2
  fi
}

