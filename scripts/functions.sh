#!/bin/sh

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

# Check Branch state and if git repo
checkBr() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    upstream=${1:-'@{u}'
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

