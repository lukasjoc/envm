"Vundle
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'wakatime/vim-wakatime'
Plugin 'dracula/vim'
Plugin 'cespare/vim-toml'
Plugin 'fatih/vim-go'
Plugin 'posva/vim-vue'
call vundle#end()
""""

filetype plugin indent on
set nocompatible
filetype off

syntax on
color dracula
set list
set listchars=tab:\ \ ,trail:.
set number
set tabstop=2 shiftwidth=2 smartindent
set expandtab
set hlsearch
set encoding=utf-8
set ruler

"Vim templates
if has("autocmd")
  augroup templates
    autocmd BufNewFile *.sh 0r ~/.vim/templates/skeleton.sh
    autocmd BufNewFile *.pl 0r ~/.vim/templates/skeleton.pl
    autocmd BufNewFile *.go 0r ~/.vim/templates/skeleton.go
    autocmd BufNewFile *.py 0r ~/.vim/templates/skeleton.py
  augroup END
endif
"""
