#!/bin/sh 

echo "I'm gonna go to battle for you. I'l triumph or die in honor."

echo "\nFighting containers.."
docker container stop $(docker container ls -a -q)

echo "\nFighting imges.."
docker rmi $(docker images -q)

echo "\nFighting networks and docker junk.."
docker system prune

echo "\nI did it sir $USER. I won with honor"

