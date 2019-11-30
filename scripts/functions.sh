#!/usr/bin/sh

# runbrewstuff updates, upgrades and cleans homebrew and caskroom
_runbrewstuff() {
  brew update 
  brew upgrade 
  bc upgrade 
  brew cleanup
  echo "DONE✅"
}

# chmodx gives files the exec permission & moves them into /usr/local/bin
_chmodx() {
  BIN_DIR="/usr/local/bin"
  chmod +x $1
  cp $1 $2
  mv $2 $BIN_DIR
}

# cooldocker lists all containers, images, networks & volumes with one command.
_cooldocker() {
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
_tooltest() {
  if ! command -v $1 ; then
    echo "$1 is not installed :( "
  fi
}

_kill_docker() {
  # pass ...
}

_get_go_tools() {
# TODO install small collection of helpfull golang developer tools
  # gocode
  # gopkgs
  # go-outline
  # go-symbols
  # guru
  # gorename
  # gotests
  # gomodifytags
  # impl
  # fillstruct
  # goplay
  # godoctor
  # dlv
  # gocode-gomod
  # godef
  # goimports
  # golint
  # TODO: install language server
}
