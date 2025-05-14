" Configuration file for vim
set modelines=0		" CVE-2007-2438

set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

let skip_defaults_vim=1

syntax enable
set background=dark
set termguicolors
colorscheme solarized8
set guifont=Cambria
set mouse=r

set number
" 文件自动缩进
set cindent
" 自动对齐
set autoindent
" 允许折叠
set foldenable
" 注释暗化
"hi comment ctermfg=0 
set clipboard=unnamed

"nnoremap  <expr>0     col('.') == 1 ? '^': '0'
nnoremap <expr> 0 virtcol('.') == indent('.')+1 ? '0' : '^'
let mapleader=" "
nnoremap <leader>wq :wq<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>s :split
nnoremap <leader>sv :vsplit
nnoremap <leader>j J

"number incresing
nnoremap _ <C-x>
vnoremap _ <C-x>
nnoremap + <C-a>
vnoremap + <C-a>

nnoremap <C-a> ^
nnoremap <C-e> $
"nnoremap 00 ^
nnoremap J 10j
nnoremap K 10k
nnoremap <Tab> ^
nnoremap <Down> gj
nnoremap <Up> gk
nnoremap > I<Tab><ESC>
nnoremap < I<BS><BS><BS><BS><ESC>

"insert mode
inoremap <C-a> <ESC>I
inoremap <C-e> <ESC>A
inoremap <Down> <ESC>gji
inoremap <Up> <ESC>gki

inoremap ( ()<LEFT>
inoremap { {}<LEFT>
inoremap [ []<LEFT>

inoremap <C-d> <Del>

" visual mode 
vnoremap j gj
vnoremap k gk
vnoremap J 10j
vnoremap K 10k
"vnoremap <C-a> ^
vnoremap <C-e> $
vnoremap <leader>j J

" Load XML comment functions
source ~/.vim/xml_comment.vim
source ~/.vim/fix_indent.vim
source ~/.vim/surround.vim
" Delete closing )
source ~/.vim/delimitMate.vim
let g:delimitMate_expand_cr = 1
