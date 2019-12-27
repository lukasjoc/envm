#!/bin/sh

runbrewstuff() {
  brew update 
  brew upgrade 
  bc upgrade 
  brew cleanup
  echo "Done {'/.\'}"
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
  docker stop $(docker container ls -aq) # stop all running containers
  docker rm $(docker container ls -aq) # remove all containers
  docker volume prune -f # prune all volumes without asking
  docker network prune -f # prune all networks without asking
  docker rmi $(docker images -aq) # remove all images
}

tooltest() {
  if ! command -v $1 >/dev/null 2>&1; then
    echo "$1 is not installed :( "
    return
  fi
}

# Check Branch state and if git repo
checkBr() {
  if [ git rev-parse --git-dir > /dev/null 2>&1 ]; then
    upstream=${1:-'@{u}'}
    local=$(git rev-parse @)
    remote=$(git rev-parse "$upstream")
    base=$(git merge-base @ "$upstream")

    git remote update
    if [ $local = $remote ]; then
      echo "Up-to-date"
    elif [ $local = $base ]; then
      echo "Need to pull"
    elif [ $remote = $base ]; then
      echo "Need to push"
    else
      echo "Diverged"
    fi
  else
    echo "Not a Git Repo"
  fi
}

