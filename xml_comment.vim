" === XML LINE COMMENT ===
function! ToggleXMLCommentLine()
    let l:line = getline('.')
    let l:indent = matchstr(l:line, '^\s*')
    let l:content = substitute(l:line, '^\s*', '', '')

    if l:content =~ '^<!--.*-->\s*$'
        let l:content = substitute(l:content, '^<!--\s*', '', '')
        let l:content = substitute(l:content, '\s*-->\s*$', '', '')
        if l:content !~ '^\s*<'
            let l:content = '<' . l:content
        endif
        if l:content !~ '>\s*$'
            let l:content = l:content . '>'
        endif
    else
        let l:content = substitute(l:content, '^\s*<\s*', '', '')
        let l:content = substitute(l:content, '\s*>\s*$', '', '')
        let l:content = '<!-- ' . l:content . ' -->'
    endif

    call setline('.', l:indent . l:content)
endfunction

" === XML BLOCK COMMENT (Updated for Visual Mode) ===
function! ToggleXMLCommentBlock()
    let l:start = line("'<")
    let l:end = line("'>")

    if l:start == l:end
        call ToggleXMLCommentLine()
        return
    endif

    let l:first = getline(l:start)
    let l:last = getline(l:end)
    let l:first_indent = matchstr(l:first, '^\s*')
    let l:last_indent = matchstr(l:last, '^\s*')

    " Detect if already commented
    let l:commented = 0
    if l:first =~ '^\s*<!--' && l:last =~ '-->\s*$'
        let l:commented = 1
    endif

    if l:commented
        " === Uncomment all styles ===
        for l:lnum in range(l:start, l:end)
            let l:line = getline(l:lnum)

            " Preserve original indentation
            let l:indent = matchstr(l:line, '^\s*')

            " Strip <!-- and -->
            let l:line = substitute(l:line, '^\s*<!--\s*', '', '')
            let l:line = substitute(l:line, '\s*-->\s*$', '', '')

            " Trim spaces
            let l:line = substitute(l:line, '^\s*', '', '')
            let l:line = substitute(l:line, '\s*$', '', '')

            " Ensure line starts with < and ends with >
            if l:line !~ '^<'
                let l:line = '<' . l:line
            endif
            if l:line !~ '>$'
                let l:line = l:line . '>'
            endif

            " Set final line with indent
            call setline(l:lnum, l:indent . l:line)
        endfor
    else
        " === Comment ===
        " Replace first < with <!--
        let l:line = getline(l:start)
        let l:line = substitute(l:line, '^\(\s*\)<', '\1<!-- ', '')
        call setline(l:start, l:line)

        " Replace last > with -->
        let l:line = getline(l:end)
        let l:line = substitute(l:line, '>\s*$', ' -->', '')
        call setline(l:end, l:line)
    endif
endfunction

" === CPP LINE COMMENT ===
function! ToggleCPPCommentLine()
    let l:line = getline('.')
    let l:indent = matchstr(l:line, '^\s*')

    if l:line =~ '^\s*//'
        " Uncomment: remove //
        let l:content = substitute(l:line, '^\s*//\s*', '', '')
    else
        " Comment: add //
        let l:content = '// ' . substitute(l:line, '^\s*', '', '')
    endif

    call setline('.', l:indent . l:content)
endfunction

" === CPP BLOCK COMMENT ===
function! ToggleCPPCommentBlock()
    let l:start = line("'<")
    let l:end = line("'>")

    " If only one line is selected, toggle line-style comment
    if l:start == l:end
        call ToggleCppCommentLine()
        return
    endif

    let l:first = getline(l:start)
    let l:last = getline(l:end)
    let l:first_indent = matchstr(l:first, '^\s*')
    let l:last_indent = matchstr(l:last, '^\s*')

    " Detect if block is already commented
    let l:commented = 0
    if l:first =~ '^\s*/\*' && l:last =~ '\*/\s*$'
        let l:commented = 1
    endif

    if l:commented
        " === Uncomment ===
        for l:lnum in range(l:start, l:end)
            let l:line = getline(l:lnum)
            let l:indent = matchstr(l:line, '^\s*')

            " First line: remove leading /*
            if l:lnum == l:start
                let l:line = substitute(l:line, '^\s*/\*\s*', '', '')
            endif

            " Last line: remove trailing */
            if l:lnum == l:end
                let l:line = substitute(l:line, '\s*\*/\s*$', '', '')
            endif

            call setline(l:lnum, l:indent . substitute(l:line, '^\s*', '', ''))
        endfor
    else
        " === Comment ===
        " First line: insert /* after indentation
        let l:line = substitute(l:first, '^\s*', '', '')
        call setline(l:start, l:first_indent . '/* ' . l:line)

        " Last line: append */ before newline
        let l:line = substitute(l:last, '^\s*', '', '')
        call setline(l:end, l:last_indent . l:line . ' */')
    endif
endfunction

function! ToggleCommentLine(symbol)
    let l:line = getline('.')
    let l:indent = matchstr(l:line, '^\s*')
    let l:symbol_escaped = escape(a:symbol, '\')

    " Check if line is already commented with the given symbol
    if l:line =~ '^\s*' . l:symbol_escaped
        " Uncomment
        let l:line = substitute(l:line, '^\s*' . l:symbol_escaped . '\s*', '', '')
    else
        " Comment
        let l:line = substitute(l:line, '^\s*', l:symbol_escaped . ' ', '')
    endif

    call setline('.', l:indent . l:line)
endfunction
" === BLOCK COMMENT ===
function! ToggleCommentBlock(symbol)
    let l:start = line("'<")
    let l:end = line("'>")
    let l:symbol_escaped = escape(a:symbol, '\')
    let l:commented = 1

    " Check if all lines are already commented
    for l:lnum in range(l:start, l:end)
        if getline(l:lnum) !~ '^\s*' . l:symbol_escaped
            let l:commented = 0
            break
        endif
    endfor

    " Toggle each line
    for l:lnum in range(l:start, l:end)
        let l:line = getline(l:lnum)

        if l:commented
            let l:line = substitute(l:line, '^\(\s*\)' . l:symbol_escaped . '\s\{1,2}', '\1', '')
        else
            let l:indent = matchstr(l:line, '^\s*')
            let l:content = substitute(l:line, '^\s*', '', '')
            let l:line = l:indent . a:symbol . '  ' . l:content
        endif

        call setline(l:lnum, l:line)
    endfor
endfunction

function! ToggleComment(mode)
  let l:ext = expand('%:e')
  let l:filename = expand('%:t')
  let l:is_block = a:mode

  let l:comment_map = {
    \   '#': [ ['sh', 'zsh', 'py'], ['.zshrc'] ],
    \   '"': [ ['vim'], ['.vimrc'] ],
    \   '%': [ ['m'], [] ]
    \ }

  let l:found = 0

  if l:ext ==# 'xml' || l:ext ==# 'mcf'
    if l:is_block
      call ToggleXMLCommentBlock()
    else
      call ToggleXMLCommentLine()
    endif
  elseif l:ext ==# 'cpp' || l:ext ==# 'h' || l:ext ==# 'hpp'
    if l:is_block
      call ToggleCPPCommentBlock()
    else
      call ToggleCPPCommentLine()
    endif
  else  
      for l:symbol in keys(l:comment_map)
        let l:ext_list = l:comment_map[l:symbol][0]
        let l:file_list = l:comment_map[l:symbol][1]

        if index(l:ext_list, l:ext) >= 0 || index(l:file_list, l:filename) >= 0
            let l:found = 1
            echo l:symbol l:file_list l:ext_list
            if l:is_block
                call ToggleCommentBlock(l:symbol)
            else
                call ToggleCommentLine(l:symbol)
            endif
            break
        endif
      endfor
      " Fallback if no match found
      if l:found == 0
          if l:is_block
              call ToggleCommentBlock('#')
          else
              call ToggleCommentLine('#')
          endif
      endif
  endif
  if !l:found
        echo "Unsupported file: " . l:filename . " (ext: " . l:ext . ")"
  endif
endfunction

" === MAPPINGS ===
nnoremap gc :call ToggleComment(0)<CR>
vnoremap gc :<C-u>call ToggleComment(1)<CR>
