#!/bin/sh

if hash figlet 2>/dev/null; then
  figlet "killdocker"
else
cat << EOF
 _    _ _ _     _            _
| | _(_) | | __| | ___   ___| | _____ _ __
| |/ / | | |/ _` |/ _ \ / __| |/ / _ \ '__|
|   <| | | | (_| | (_) | (__|   <  __/ |
|_|\_\_|_|_|\__,_|\___/ \___|_|\_\___|_|

EOF
fi

cat << EOF
Author: lukasjoc, 2019 (https://lukasjoc.com)
Desc: Kills all docker containers, volumes, networks and images
===================================================
EOF

kill() {
  declare -a commands=(
    "docker rmi $(docker images -q)"
    "docker stop $(docker ps -q) && docker rm $(docker ps -a -q)"
    "docker network rm $(docker network ls -q)"
    "docker volume rm $(docker volume ls -q)"
  )
  for command in "${commands[@]}"
  do
    echo "CAUTION! Killing... [^C to stop]"
    exec $command
  done
}

echo " 🐳 Killing Docker containers, volumes, networks and images"
read -p "Do you want to proceed? [y/N]" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  exit 1
else
kill
echo "Done killing, cleaning docker and tools"
fi
