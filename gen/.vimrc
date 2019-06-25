"Packages
set nocompatible
filetype off

"[!!]Plugins need single quotes | Vundle
set rtp+=~/.vim/bundle/Vundle.vim

"Plugins
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic'
call vundle#end()
filetype plugin indent on

syntax on
colorscheme desert
set number
set smartindent 
set tabstop=2 
set shiftwidth=2
set expandtab
set hlsearch
set encoding=utf-8
set ruler

"inoremap {<cr> {<cr>}<c-o><s-o>
"inoremap [<cr>] [<cr>]<c-o><s-o>
"inoremap (<cr>)(<cr>)<c-o><s-o>

