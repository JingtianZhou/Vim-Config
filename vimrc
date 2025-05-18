" Vim plug
call plug#begin()
    Plug 'ojroques/vim-oscyank', {'branch': 'main'}
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/asyncomplete-file.vim'
    " theme
    Plug 'embark-theme/vim', { 'as': 'embark', 'branch': 'main' }
    Plug 'nordtheme/vim'
    Plug 'itchyny/lightline.vim' " Bottom light line
    " File tree explorer
    Plug 'preservim/nerdtree'
    Plug 'ryanoasis/vim-devicons'
    Plug 'PhilRunninger/nerdtree-visual-selection'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
call plug#end()
let mapleader=" "

" Themes
set termguicolors
"  let g:tokyonight_style = 'storm' " available: night, storm
"  let g:tokyonight_enable_italic = 1
"  let g:tokyonight_transparent_background = 1
colorscheme nord
set background=dark
 set guifont=Cambria
set laststatus=2 "lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }

" File explorer
nnoremap <leader>e :NERDTreeToggle<CR>
nnoremap <leader>b :NERDTreeFocus<CR>
nnoremap <leader>f :NERDTreeFind<CR>
let g:NERDTreeMapOpenSplit = '-'
let g:NERDTreeMapOpenVSplit = '\'
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif

" New tab
nnoremap <leader>t :tabnew<CR>
nnoremap [ gt
nnoremap ] gT

" Fzf
nnoremap <leader>f :FZF<CR>

" Clipboard
nnoremap <leader>y <Plug>OSCYankOperator 
nnoremap <leader>yy <Plug>OSCYankOperator_
vnoremap <leader>y <Plug>OSCYankVisual
" Configuration file for vim
set modelines=0		
set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround
syntax enable
set encoding=UTF-8
" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing
let skip_defaults_vim=1

set mouse=r
set number
" 文件自动缩进
set cindent
" 自动对齐
set autoindent
" 允许折叠
set foldenable
" 注释暗化
set clipboard=unnamed

"nnoremap  <expr>0     col('.') == 1 ? '^': '0'
nnoremap <expr> 0 virtcol('.') == indent('.')+1 ? '0' : '^'
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

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

" Use arrow or tab to select auto-suggestion
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <Down>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Up> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"
