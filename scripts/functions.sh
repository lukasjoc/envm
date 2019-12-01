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

# FIXME: this is not recognizing docker command
cooldocker() {
  declare -a commands=( 
    "images"
    "container ls -a"
    "network ls"
    "volume ls"
  )
  docker="docker"
  for cmd ($commands); do
    "$docker $cmd"
  done
}

# FIXME: this is not recognizing docker command
killdocker() {
  declare -a commands=(
    "stop $(docker container ls -a -q)"
    "rm $(docker container ls -a -q)"
    "volume prune"
    "network prune"
    "rmi $(docker images -a -q)"
  )
  docker="docker"
  for cmd ($commands); do
    "$docker $cmd"
  done
}

tooltest() {
  if ! command -v $1; then
    echo "$1 is not installed :( "
    exit
  fi
}

# Reformat date output, remove all whitespaces
# TOTHIS: variant1(default): Sun-Dec1-16:26:01-CET-2019, variant2(-s --> short): 1-12-2019
sdate() {
  echo "DD-MM-YYYY" 
}