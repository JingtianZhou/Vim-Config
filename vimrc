" Configuration file for vim
set modelines=0		" CVE-2007-2438

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

let skip_defaults_vim=1
syntax enable
" 文件自动缩进
set cindent
" 自动对齐
set autoindent
" 允许折叠
set foldenable
noremap  <expr>0     col('.') == 1 ? '^': '0'

let mapleader=" "
nnoremap <leader>l L
nnoremap <leader>h H
nnoremap <leader>wq :wq<CR>
nnoremap <leader>q :q!<CR>
inoremap kk <ESC>

nnoremap H ^
nnoremap L $
nnoremap <C-a> ^
nnoremap <C-e> $
nnoremap 00 ^

inoremap <C-a> <ESC>I
inoremap <C-e> <ESC>A

vnoremap j gj
vnoremap k gk
vnoremap <C-a> ^
vnoremap <C-e> $
nnoremap L ^
nnoremap H $

