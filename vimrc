" Configuration file for vim
set modelines=0		" CVE-2007-2438

set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround

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
" let g:delimitMate_expand_cr = 1

nnoremap <C-\> :terminal<CR>
tnoremap <Esc> <C-\><C-n>
tnoremap <C-\> <C-\><C-n>:q!<CR>

nnoremap < <<
nnoremap > I<Tab><ESC>

" Vim plug
call plug#begin()
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
call plug#end()

" Enable asyncomplete
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_remove_duplicates = 1

if executable('pylsp')
    " pip install python-lsp-server
    au User lsp_setup call lsp#register_server({
        \ 'name': 'pylsp',
        \ 'cmd': {server_info->['pylsp']},
        \ 'allowlist': ['python'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
    nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
