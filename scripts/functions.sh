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

# TODO: add counting of images, and so on
# cooldocker() {
#   checkdocker()
#   declare -a commands=( 
#     "images" 
#     "container ls -a" 
#     "network ls" 
#     "volume ls"
#   )
#   for cmd in "${commands[@]}" ; do
#     docker $cmd
#   done
# }

# killdocker() {
#   checkdocker()
#   declare -a commands=(
#     "container stop ${docker container ls}"
#     "container rm ${docker container ls -a}"
#     "rmi ${docker images -qa}"
#     "network rm ${docker network ls}"
#     "volume rm ${docker volume ls}"
#   )

#   for cmd in "${docker_stats[@]}" ; do
#     docker $cmd
#     echo "$cmd"
#   done
# }

tooltest() {
  if ! command -v $1 ; then
    echo "$1 is not installed :( "
    exit
  fi
}

checkdocker() {
  if ! command -v docker ; then
    echo "Docker Not Installed"
  fi
}