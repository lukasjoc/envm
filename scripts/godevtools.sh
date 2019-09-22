#!/bin/sh

cat << "EOF"
                 _            _              _
  __ _  ___   __| | _____   _| |_ ___   ___ | |___
 / _` |/ _ \ / _` |/ _ \ \ / / __/ _ \ / _ \| / __|
| (_| | (_) | (_| |  __/\ V /| || (_) | (_) | \__ \
 \__, |\___/ \__,_|\___| \_/  \__\___/ \___/|_|___/
 |___/

EOF

<< EOF
lukasjoc, 2019
https://lukasjoc.com
===================================================

EOF

e

 echo "Installing go tools" &&
sleep 1 &&
echo "Loading..." &&
go get github.com/mdempsky/gocode &&
go get github.com/uudashr/gopkgs/cmd/gopkgs &&
go get github.com/ramya-rao-a/go-outline &&
go get github.com/acroca/go-symbols &&
go get golang.org/x/tools/cmd/guru &&
go get golang.org/x/tools/cmd/gorename &&
go get github.com/go-delve/delve/cmd/dlv &&
go get github.com/stamblerre/gocode &&
go get github.com/rogpeppe/godef &&
go get golang.org/x/tools/cmd/goimports &&
go get golang.org/x/lint/golint &&
echo "Done installing go tools into $GOAPTH/bin"
