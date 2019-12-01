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

killdocker() {
  # checkdocker()
  a1=$1
  a2=$2
  declare -a commands=(
    hello
    world
    # "container stop ${docker container ls}"
    # "container rm ${docker container ls -a}"
    # "rmi ${docker images -qa}"
    # "network rm ${docker network ls}"
    # "volume rm ${docker volume ls}"
  )

  echo "hello"
  echo "world"
  echo "$a1 - $a2 "
  # for cmd in "${commands[@]}" do
  #   echo "$cmd"
  # done
}

tooltest() {
  if [ ! command -v $1 ] ; then
    echo "$1 is not installed :( "
    exit
  fi
}

checkdocker() {
  if [ ! command -v docker ] ; then
    echo "Docker Not Installed"
  fi
}

# Reformat date output, remove all whitespaces
# TOTHIS: variant1(default): Sun-Dec1-16:26:01-CET-2019, variant2(-s --> short): 1-12-2019
sdate() {
  echo "DD-MM-YYYY" 
}