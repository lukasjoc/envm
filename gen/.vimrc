"Packages
set nocompatible
filetype off

"[!!]Plugins need single quotes | Vundle
set rtp+=~/.vim/bundle/Vundle.vim

"Plugins
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
call vundle#end()
filetype plugin indent on

syntax on
colorscheme koehler

set listchars=trail:.,tab:.,
set list
set foldmethod=indent
set number
set tabstop=2 shiftwidth=2 smartindent
set expandtab
set hlsearch
set encoding=utf-8
set ruler
