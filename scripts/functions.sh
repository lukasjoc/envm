#!/usr/bin/sh

# runbrewstuff updates, upgrades and cleans homebrew and caskroom
function runbrewstuff() {
  brew update 
  brew upgrade 
  bc upgrade 
  brew cleanup
  echo "DONE✅"
}

# chmodx gives files the exec permission & moves them into /usr/local/bin
function chmodx() {
  BIN_DIR="/usr/local/bin"
  chmod +x $1
  cp $1 $2
  mv $2 $BIN_DIR
}

# cooldocker lists all containers, images, networks & volumes with one command.
function cooldocker() {
  declare -a docker_stats=(
    "$(docker images)"
    "$(docker container ls -a)"
    "$(docker network ls)"
    "$(docker volume ls)"
  )
  for docker_stat in "docker_stats[@]" ; do
    echo "$docker_stat"
  done
}

# tooltest tests if a($1) given cmdline tool is installed & reachable through the $PATH
function tooltest() {
  if ! command -v $1 ; then
    echo "$1 is not installed :( "
  fi
}

# kill_docker ...
function kill_docker() {
  # pass ...
}

# get_go_tools  ...
function get_go_tools() {
# TODO install small collection of helpfull golang developer tools
}
