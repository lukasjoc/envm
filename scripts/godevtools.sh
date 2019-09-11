# TODO: Write little script that installs all relevant golang tools and language server from google 


figlet "go-devtools"

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
