#!/bin/sh

if hash figlet 2>/dev/null; then
  figlet "fuckyoudsstore"
else
cat << EOF
  __            _                          _         _ 
 / _|_   _  ___| | ___   _  ___  _   _  __| |___ ___| |_ ___  _ __ ___ 
| |_| | | |/ __| |/ / | | |/ _ \| | | |/ _` / __/ __| __/ _ \| '__/ _ \
|  _| |_| | (__|   <| |_| | (_) | |_| | (_| \__ \__ \ || (_) | | |  __/
|_|  \__,_|\___|_|\_\\__, |\___/ \__,_|\__,_|___/___/\__\___/|_|  \___|
                     |___/
EOF
fi
<< EOF
lukasjoc, 2019
https://lukasjoc.com
Deletes .DS_Store files common to hate on macOS
===================================================
EOF

function delete {
  # TODO: delete .DS_Store files
}

function scan {
  # TODO: scan all user paths for .DS_Store files and call delete
}

tools
