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

" Map <leader>c in visual mode to call the function
vnoremap <silent> <leader>c :<C-u>call FixIndentVisual()<CR>
