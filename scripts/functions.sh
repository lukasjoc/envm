#!/usr/local/bin/bash

runbrewstuff() {
  brew update 
  brew upgrade 
  bc upgrade 
  brew cleanup
  echo " ✅ DONE"
}

chmodx() {
  chmod +x $1
  cp $1 $2
  mv $2 "/usr/local/bin"
}

# FIXME: this is not nice but it works. Somehow the docker command is not recognized during looping
cooldocker() {
  echo
  docker images
  echo
  docker container ls -a
  echo
  docker network ls
  echo
  docker volume ls
}

# FIXME: this is not nice but it works. Somehow the docker command is not recognized during looping
killdocker() {
  echo
  docker stop $(docker container ls -a -q)
  echo
  docker rm $(docker container ls -a -q)
  echo
  docker volume prune
  echo
  docker network prune
  echo
  docker rmi $(docker images -a -q)
}

tooltest() {
  if ! command -v $1; then
    echo "$1 is not installed :( "
    exit
  fi
}

# Checks git branches states
checkBr() {
  UPSTREAM=${1:-'@{u}'}
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse "$UPSTREAM")
  BASE=$(git merge-base @ "$UPSTREAM")
  git remote update
  if [ $LOCAL = $REMOTE ]; then
    echo "Up-to-date"
  elif [ $LOCAL = $BASE ]; then
    echo "Need to pull"
  elif [ $REMOTE = $BASE ]; then
    echo "Need to push"
  else
    echo "Diverged"
  fi
}

# Reformat date output, remove all whitespaces
# TOTHIS: variant1(default): Sun-Dec1-16:26:01-CET-2019, variant2(-s --> short): 1-12-2019
#sdate() {
#  echo "DD-MM-YYYY"
#}
