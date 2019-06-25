"Packages
set nocompatible
filetype off

"[!!]Plugins need single quotes | Vundle
set rtp+=~/.vim/bundle/Vundle.vim

"Plugins
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/syntastic'
Plugin 'dracula/vim', {'rtp': '.vim/bundle/vim/colors/dracula.vim'}
call vundle#end()
filetype plugin indent on

syntax on
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

