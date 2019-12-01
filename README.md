# envm

> 🍕 Environment Files, Vim Hackeros and other cool stuff

### Prerequisites
- ZSH Shell in ``/usr/local/bin/zsh`` or ``/usr/local/bin/zsh``
- OH-MY-ZSH installed into ``$HOME/.oh-my-zsh``
- Vundle installed to ``~/.vim/bundle/Vundle``

### Setup envm:
- ``git clone https://github.com/lukasjoc/envm.vim.git ~/.envm``
- Type ``vim`` and then type ``Shift+:PluginInstall``
- Open ``~/.zshrc`` and append ENVM_WDIR="PATH_TO_YOUR_WORKING_DIR"

### SYNOPSIS:
- $ENVM => Path of the envm repository on your system usually ``~/.envm``
- $ENVM_WDIR => Path to your working dir. The place where the magic happens
- $ENVM_AUTO_UPDATE => Auto Update ENVM if changes have been detected
[lukasjoc](https://lukasjoc.com), year