" Vim plug
call plug#begin()
    Plug 'liuchengxu/vim-which-key'
    Plug 'ojroques/vim-oscyank', {'branch': 'main'}
    Plug 'prabirshrestha/vim-lsp'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'prabirshrestha/asyncomplete-file.vim'
    Plug 'keremc/asyncomplete-clang.vim'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    Plug 'rhysd/vim-clang-format'
    Plug 'gcmt/wildfire.vim'
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

" WhichKey Register
nnoremap <silent> <leader> :<c-u>WhichKey '<Space>'<CR>
call which_key#register('<Space>', "g:which_key_map")
" Hide status bar
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
set timeout timeoutlen=300 ttimeoutlen=100
let g:which_key_map = {}

" Supertablog
let g:SuperTabDefaultCompletionType = "<c-n>"

" Transparent
let t:is_transparent = 0
function! Transparent()
    if t:is_transparent == 0
        hi Normal guibg=NONE ctermbg=NONE
        let t:is_transparent = 1
    else
        set background=dark
        hi Normal guibg=#2E3440 ctermbg=black
        let t:is_transparent = 0
    endif
endfunction
nnoremap <silent> <leader>ct :call Transparent()<CR>
" autocmd VimEnter * call Transparent()

" Themes
set termguicolors
"  let g:tokyonight_style = 'storm' " available: night, storm
"  let g:tokyonight_enable_italic = 1
"  let g:tokyonight_transparent_background = 1
colorscheme nord
let g:nord_italic_comments = 1
augroup nord
    autocmd!
    autocmd ColorScheme * highlight shDerefSimple ctermfg=6 guifg=#88C0D0
    autocmd ColorScheme * highlight shDerefVar ctermfg=6 guifg=#88C0D0
    autocmd ColorScheme * highlight shVariable ctermfg=6 guifg=#88C0D0
augroup END
set background=dark
set guifont=Cambria
set laststatus=2 "lightline
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ }


"Nerd File explorer ======================================================================
function! ToggleOrRun(cmd)
  " Check if NERDTree buffer is open
  if exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1
    " If open, toggle (close it)
    NERDTreeToggle
  else
    " If closed, run the given command
    execute a:cmd
  endif
endfunction
nnoremap <leader>e :call ToggleOrRun("NERDTreeFind")<CR>
nnoremap <leader>b :call ToggleOrRun("NERDTreeCWD")  <CR>
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nc :NERDTreeCWD<CR>
nnoremap <leader>n1 :Bookmark 1<CR>
nnoremap <leader>n2 :Bookmark 2<CR>
nnoremap <leader>n3 :Bookmark 3<CR>
nnoremap <leader>n4 :Bookmark 4<CR>
nnoremap <leader>1 :OpenBookmark 1<CR>
nnoremap <leader>2 :OpenBookmark 2<CR>
nnoremap <leader>3 :OpenBookmark 3<CR>
nnoremap <leader>4 :OpenBookmark 4<CR>
let g:NERDTreeMapOpenSplit = 's'
let g:NERDTreeMapOpenVSplit = 'v'
let g:NERDTreeMapToggleHidden = '.'
let g:NERDTreeMapChangeRoot = 'L'
let g:NERDTreeMapUpdir = 'H'

function! NERDTreePreviewAction(action, ...)
  let l:nerdtree_win = winnr() " Save current window (NERDTree)
  wincmd l " Jump to the preview window (to the right of NERDTree)
  if a:action ==# 'close'
    " Switch back to previous buffer
    execute "b#"
  elseif a:action ==# 'scroll'
    " a:1 holds the scroll key sequence
    execute "normal! " . a:1
  endif
  " Return to NERDTree
  execute l:nerdtree_win . "wincmd w"
endfunction
autocmd FileType nerdtree nnoremap <buffer> <Esc>  :call NERDTreePreviewAction('close')<CR>
autocmd FileType nerdtree nnoremap <buffer> <C-d>  <Cmd>call NERDTreePreviewAction('scroll', '<C-d>')<CR>
autocmd FileType nerdtree nnoremap <buffer> <C-u>  <Cmd>call NERDTreePreviewAction('scroll', "\<C-u>")<CR>

" Start NERDTree when Vim is started without file arguments.
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
" Close the tab if NERDTree is the only window remaining in it.
autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | call feedkeys(":quit\<CR>:\<BS>") | endif
" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if &buftype != 'quickfix' && getcmdwintype() == '' | silent NERDTreeMirror | endif
" locate the current file in NERDTree
" autocmd BufWinEnter * NERDTreeFind
" =====================================================================================================
" New tab
nnoremap <leader>t :tabnew<CR>
nnoremap [ gt
nnoremap ] gT

" Fzf
nnoremap <leader>ff :FZF<CR>
nnoremap <leader>fF :FZF ../<CR>
nnoremap <leader>fg :FZF ~/<CR>
nnoremap <leader>fh :History<CR>
let g:fzf_action = {
   \ 'ctrl-n': 'tab split',
   \ 'ctrl-s': 'split',
   \ 'ctrl-v': 'vsplit' }

" Clipboard
nnoremap <leader>y <Plug>OSCYankOperator 
nnoremap <leader>yy <Plug>OSCYankOperator_
vnoremap <leader>y <Plug>OSCYankVisual

" Clang format
nnoremap <leader>cf :ClangFormat<CR>
" Configuration file for vim
set modelines=0		
set ignorecase
set tabstop=4
set shiftwidth=4
set expandtab
set shiftround
syntax enable
set encoding=UTF-8
set noswapfile
" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing
let skip_defaults_vim=1

" Open .vimrc quickly
command! R tabedit $MYVIMRC
autocmd BufWritePost $MYVIMRC source $MYVIMRC

" Disable auto comment next line
autocmd BufNewFile,BufRead * setlocal formatoptions-=cro

set mouse=r
set number
" 文件自动缩进
set cindent
" 自动对齐
set autoindent
" 允许折叠
set foldenable
set clipboard=unnamed
" Only use current buffer (.) for keyword completion so it doesn't search files
set complete=.

"nnoremap  <expr>0     col('.') == 1 ? '^': '0'
nnoremap <expr> 0 virtcol('.') == indent('.')+1 ? '0' : '^'
nnoremap <leader>wq :wq<CR>
nnoremap <leader>q :q!<CR>
nnoremap <leader>s :split<CR>
nnoremap <leader>sv :vsplit<CR>
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
nnoremap <Down> gj
nnoremap <Up> gk

"insert mode
inoremap <C-a> <ESC>I
inoremap <C-e> <ESC>A
inoremap <Down> <ESC>gji
inoremap <Up> <ESC>gki

nnoremap <C-i> <Tab>
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
" Map <leader>c in visual mode to call the function
vnoremap <silent> <leader>cc :<C-u>call FixIndentVisual()<CR>
source ~/.vim/surround.vim
" Delete closing )
source ~/.vim/delimitMate.vim
" let g:delimitMate_expand_cr = 1

" terminal
nnoremap <C-\> :terminal<CR>
" tnoremap <Esc> <C-\><C-n>
tnoremap <C-\> <C-\><C-n>:q!<CR>

"Window shift
nnoremap <C-Left>  :vertical resize +20<CR>
nnoremap <C-Right> :vertical resize -20<CR>
nnoremap <C-Up>    :resize -10<CR>
nnoremap <C-Down>  :resize +10<CR>

nnoremap < <<
nnoremap > >>

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
    " nmap <buffer> K <plug>(lsp-hover)
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

" Registering clangd LSP with asyncomplete
if executable('clangd')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'clangd',
        \ 'cmd': {server_info->['clangd']},
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \ })
endif
let g:lsp_diagnostics_enabled = 0         " disable diagnostics support 
autocmd User asyncomplete_setup call asyncomplete#register_source(
    \ asyncomplete#sources#clang#get_source_options())

" Use arrow or tab to select auto-suggestion
" inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : asyncomplete#force_refresh()
inoremap <expr> <Down>  pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <Up>    pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>" 

" WhichKey maps
" let g:which_key_ignore_outside_mappings = 1
let g:which_key_map.f = 'Fzf' 
let g:which_key_map.cc = 'Sync Indent' 
let g:which_key_map.ct = 'Call transparent' 
let g:which_key_map.cf = 'Clang format' 
let g:which_key_map.f = {
      \ 'name' : 'Fzf',
      \ 'f' : 'Fzf ./' ,
      \ 'h' : 'Fzf history' ,
      \ 'F' : 'Fzf ../' ,
      \ 'g' : 'Fzf ~/' ,
      \ }
let g:which_key_map.t = 'Tab new'
let g:which_key_map.n = {
      \ 'name' : 'Nerd Tree',
      \ 'f' :  'Nerd Tree Find' ,
      \ 'c' :  'Nerd Tree CWD' ,
      \ '1' :  'Bookmark 1' ,
      \}
let g:which_key_map.n2 = 'which_key_ignore' 
let g:which_key_map.n3 = 'which_key_ignore' 
let g:which_key_map.n4 = 'which_key_ignore' 
let g:which_key_map.j =  'which_key_ignore' 
let g:which_key_map.1 =  'which_key_ignore' 
let g:which_key_map.2 =  'which_key_ignore' 
let g:which_key_map.3 =  'which_key_ignore' 
let g:which_key_map.4 =  'which_key_ignore' 
let g:which_key_map.q =  'which_key_ignore' 
let g:which_key_map.F =  'which_key_ignore' 
let g:which_key_map.yy =  'which_key_ignore' 
