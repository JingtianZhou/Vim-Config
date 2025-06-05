" Use <leader>c to indent rows to the first row.
function! FixIndentVisual()
  " Save current position
  let l:save_cursor = getpos(".")

  " Get start and end of visual selection
  normal! `<
  let l:start = line(".")
  normal! `>
  let l:end = line(".")

  " Get indent from the first line of the selection
  let l:base_indent = matchstr(getline(l:start), '^\s*')

  " Start from the second line in the selection
  for l:lnum in range(l:start + 1, l:end)
    let l:line = getline(l:lnum)
    let l:trimmed = substitute(l:line, '^\s*', '', '')
    call setline(l:lnum, l:base_indent . l:trimmed)
  endfor

  " Restore cursor
  call setpos('.', l:save_cursor)
endfunction

" Use < and > in visual mode to indent
function! StayIndentVisual(direction)
  " Save the visual selection marks
  normal! gv
  " Perform indent in the given direction
  execute "normal! " . a:direction
  " Reselect the visual area
  normal! gv
endfunction

" Remap < and > in visual mode to keep selection
vnoremap <silent> < <Esc>:call StayIndentVisual('<')<CR>
vnoremap <silent> > <Esc>:call StayIndentVisual('>')<CR>
