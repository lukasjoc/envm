#!/bin/sh

if hash figlet 2>/dev/null; then
  figlet "godevtools"
else
cat << EOF
                 _            _              _
  __ _  ___   __| | _____   _| |_ ___   ___ | |___
 / _` |/ _ \ / _` |/ _ \ \ / / __/ _ \ / _ \| / __|
| (_| | (_) | (_| |  __/\ V /| || (_) | (_) | \__ \
 \__, |\___/ \__,_|\___| \_/  \__\___/ \___/|_|___/
 |___/
EOF
fi

<< EOF
lukasjoc, 2019
https://lukasjoc.com
Installs common go development tools into $GOROOT/bin
===================================================
EOF

function tools {
  declare -a tools=(
    "github.com/mdempsky/gocode"
    "github.com/uudashr/gopkgs/cmd/gopkgs"
    "github.com/ramya-rao-a/go-outline"
    "github.com/acroca/go-symbols"
    "golang.org/x/tools/cmd/guru"
    "golang.org/x/tools/cmd/gorename"
    "github.com/go-delve/delve/cmd/dlv"
    "github.com/stamblerre/gocode"
    "github.com/rogpeppe/godef"
    "golang.org/x/tools/cmd/goimports"
    "golang.org/x/lint/golint"
  )

  for tool in "${tools[@]}"
  do
    go get $tool
    echo "TOOL: $tool SUCCESS"
  done

}

echo "Installing go tools"
echo "Loading..."
tools
echo "Done installing go tools into GOPATH"
