#!/bin/sh

if hash figlet 2>/dev/null; then
  figlet "makeglobal"
else
cat << EOF
                 _              _       _           _
 _ __ ___   __ _| | _____  __ _| | ___ | |__   __ _| |
| '_ ` _ \ / _` | |/ / _ \/ _` | |/ _ \| '_ \ / _` | |
| | | | | | (_| |   <  __/ (_| | | (_) | |_) | (_| | |
|_| |_| |_|\__,_|_|\_\___|\__, |_|\___/|_.__/ \__,_|_|
                          |___/
EOF
fi

cat << EOF
Author: lukasjoc, 2019 (https://lukasjoc.com)
Desc: Makes scripts executable and moves them into /usr/local/bin
===================================================
EOF

makeGlobal() {
  # TODO: clone script and move into /usr/local/bin
  echo "moving... $1 "
}

echo "Makeing scripts executable and moving cloned version into /usr/local/bin..."
read -p "Do you want to proceed? [y/N]" -n 1 -r
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
  exit 1
else
makeGlobal "$1"
echo "Done moving $1 into /usr/local/bin"
fi
