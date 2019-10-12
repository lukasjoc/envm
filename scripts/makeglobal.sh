#!/bin/sh

destDIR=/usr/local/bin

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
Desc: Makes scripts executable and moves them into $destDIR
Usage: makeglobal {srcName} {destName}
===================================================
EOF

echo "Makeing scripts executable and moving cloned version into $destDIR..."
read -p "Do you want to proceed? [y/N]" -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] 
then
  exit 1
else
  if [[ ! $# == 2 ]]
  then
    echo "Usage: makeglobal {srcName} {destName}"
    exit 1
  else
    chmod +x $1
    cp $1 $2
    mv $2 $destDIR
  fi
  echo "Done moving $2 into $destDIR"
fi
