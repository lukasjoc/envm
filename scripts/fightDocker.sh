#!/bin/sh


cat << "EOF"
   __ _       _     _   _____             _                 _
  / _(_)     | |   | | |  __ \           | |               | |
 | |_ _  __ _| |__ | |_| |  | | ___   ___| | _____ _ __ ___| |__
 |  _| |/ _` | '_ \| __| |  | |/ _ \ / __| |/ / _ | '__/ __| '_ \
 | | | | (_| | | | | |_| |__| | (_) | (__|   |  __| |_ \__ | | | |
 |_| |_|\__, |_| |_|\__|_____/ \___/ \___|_|\_\___|_(_)|___|_| |_|
         __/ |
        |___/
EOF

<< EOF
lukasjoc, $(date +'%Y')
https://lukasjoc.com
===================================================

EOF

echo "\nI'm gonna go to battle for you. I'll triumph or die in honor."

echo "\nFighting containers.."
docker container stop $(docker container ls -a -q)
docker container rm $(docker container ls -a -q)

echo "\nFighting imges.."
docker rmi $(docker images -q)

echo "\nFighting networks and docker junk.."
docker system prune

docker container ls && echo 🐳====EMTY && docker images && echo 🐳====EMTY && docker network ls

echo "\nI did it sir $USER. I won with honor"

