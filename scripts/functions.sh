#!/usr/local/bin/bash

runbrewstuff() {
  brew update 
  brew upgrade 
  bc upgrade 
  brew cleanup
  echo " ✅ DONE"
}

chmodx() {
  BIN_DIR="/usr/local/bin"
  chmod +x $1
  cp $1 $2
  mv $2 $BIN_DIR
}

cooldocker() {
  declare -a commands=(
    "images"
    "container ls -a"
    "network ls"
    "volume ls"
  )
  for cmd in "commands[@]" ; do
    echo "$cmd"
  done
}

killdocker() {
  declare -a commands=(
    "container stop ${docker container ls}"
    "container rm ${docker container ls -a}"
    "rmi ${docker images -qa}"
    "network rm ${docker network ls}"
    "volume rm ${docker volume ls}"
  )
  for cmd in "docker_stats[@]" ; do
    docker $cmd
    echo "$cmd"
  done
}

tooltest() {
  if ! command -v $1 ; then
    echo "$1 is not installed :( "
    exit
  fi
}

createCobraApp() {
  if ! command -v cobra ; then
    echo "Cobra is not installed..."
    echo "Install it with go get -u github.com/spf13/cobra/cobra"
    exit
  fi
  cobra init test2 / 
  --pkg-name github.com/lukasjoc/test / 
  --config test2 / 
  --viper=false / 
  -l=MIT /
  -a $USER
}