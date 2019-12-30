#!/bin/sh

runbrewstuff() {
  echo " 🍺 Running brew update..."
  brew update

  echo " 🍺 Running brew upgrade..."
  brew upgrade

  echo " 🍺  Running brew cask upgrade..."
  brew cask upgrade

  echo " 🍻 Running brew cleanup..."
  brew cleanup

  brew doctor
  echo "Done ;)"
}

makeglobal() {
  chmod +x $1
  cp $1 $2
  mv $2 "/usr/local/bin"
}

cooldocker() {
  # List all images and count them
  echo "\nIMAGES: $(docker images -aq | wc -l)"
  docker images -a --digests && echo

  # List all containers and count them
  echo "\nCONTAINER: $(docker container ls -aq | wc -l)"
  docker container ls -a && echo

  # List all docker networks and count them 
  echo "\nNETS: $(docker network ls -q | wc -l)"
  docker network ls && echo

  # List all volumes and count them
  echo "\nVOLUMES: $(docker volume ls -q | wc -l)"
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
  if ! command -v exercism >/dev/null 2>&1; then
    echo "Exercism is not installed... "
    return
  fi
  exercism submit $1
}


