"Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'wakatime/vim-wakatime'
Plugin 'fatih/vim-go'
call vundle#end()
""""

filetype plugin indent on
set nocompatible
filetype off
syntax on
set paste
set list
set listchars=tab:\ \ ,trail:.
set number
set tabstop=2 shiftwidth=2 smartindent
set expandtab
set hlsearch
set encoding=utf-8
set ruler
set backspace=indent,eol,start
