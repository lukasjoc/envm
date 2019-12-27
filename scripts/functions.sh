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
  echo "IMAGES: $(docker images -aq | wc -l)"
  docker images -a
  
  # List all containers and count them
  echo "CONTAINER: $(docker container ls -aq | wc -l)"
  docker container ls -a

  # List all docker networks and count them 
  echo "NETS: $(docker network ls -aq | wc -l)"
  docker network ls

  # List all volumes and count them
  echo "VOLUMES: $(docker volume ls -aq | wc -l)"
  docker volume ls
}

killdocker() {
  echo "Do you wish to install this program?"
  select yn in "Yes" "No"
  case $yn in
      Yes )
        docker stop $(docker container ls -aq) # stop all running containers
        docker rm $(docker container ls -aq) # remove all containers
        docker volume prune -f # prune all volumes without asking
        docker network prune -f # prune all networks without asking
        docker rmi $(docker images -aq) # remove all images
        ;;
      No ) exit;;
  esac
}

tooltest() {
  if [[ ! command -v $1 >/dev/null 2>&1 ]]; then
    echo "$1 is not installed :( "
    return
  fi
}

# Check Branch state and if git repo
checkBr() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
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

