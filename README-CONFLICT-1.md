# envm

> Environment files and stuff

## Prerequisites
- zsh,bash -> `which zsh|bash`
- Vundle installed to ``~/.vim/bundle/Vundle``

## Setup envm:
- ``git clone git@github.com:lukasjoc/envm.vim.git ~/.envm``
- Copy a zshrc|bashrc template from the $envm/templates into $HOME
- Setup envm Environment Variables ($envm, $envm_wdir, $enable_envm_auto_update)
- Type ``vim`` and then type ``Shift+:PluginInstall``

## SYNOPSIS:
- ``$envm`` => Path of the envm repository on your system only in ``~/.envm``
- ``$envm_wdir`` => Path to your working dir. The place where the magic happens
- ``$envm_auto_update_days`` => if >= 1 update is enabled

[lukasjoc](https://lukasjoc.com), 2020
