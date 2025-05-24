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

" === BASH LINE COMMENT ===
function! ToggleBashCommentLine()
    let l:line = getline('.')
    let l:indent = matchstr(l:line, '^\s*')
    if l:line =~ '^\s*#'
        " Uncomment
        let l:line = substitute(l:line, '^\s*#\s*', '', '')
    else
        " Comment
        let l:line = substitute(l:line, '^\s*', '# ', '')
    endif
    call setline('.', l:indent . l:line)
endfunction

" === BASH BLOCK COMMENT ===
function! ToggleBashCommentBlock()
    let l:start = line("'<")
    let l:end = line("'>")
    let l:commented = 1

    " Detect if all lines are commented
    for l:lnum in range(l:start, l:end)
        if getline(l:lnum) !~ '^\s*#'
            let l:commented = 0
            break
        endif
    endfor

    " Toggle each line
    for l:lnum in range(l:start, l:end)
        let l:line = getline(l:lnum)

        if l:commented
            let l:line = substitute(l:line, '^\(\s*\)#\s\{1,2}', '\1', '')
        else
            " Comment: add # at the very beginning (before indent)
            let l:indent = matchstr(l:line, '^\s*')
            let l:content = substitute(l:line, '^\s*', '', '')
            let l:line = l:indent . '#  ' . l:content
        endif

        call setline(l:lnum, l:line)
    endfor
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

" === VIM LINE COMMENT ===
function! ToggleVIMCommentLine()
    let l:line = getline('.')
    let l:indent = matchstr(l:line, '^\s*')
    if l:line =~ '^\s*\"'
        " Uncomment
        let l:line = substitute(l:line, '^\s*\"\s*', '', '')
    else
        " Comment
        let l:line = substitute(l:line, '^\s*', '\" ', '')
    endif
    call setline('.', l:indent . l:line)
endfunction
" === VIM BLOCK COMMENT ===
function! ToggleVIMCommentBlock()
    let l:start = line("'<")
    let l:end = line("'>")
    let l:commented = 1

    " Detect if all lines are commented
    for l:lnum in range(l:start, l:end)
        if getline(l:lnum) !~ '^\s*\"'
            let l:commented = 0
            break
        endif
    endfor

    " Toggle each line
    for l:lnum in range(l:start, l:end)
        let l:line = getline(l:lnum)

        if l:commented
            let l:line = substitute(l:line, '^\(\s*\)\"\s\{1,2}', '\1', '')
        else
            " Comment: add " at the very beginning (before indent)
            let l:indent = matchstr(l:line, '^\s*')
            let l:content = substitute(l:line, '^\s*', '', '')
            let l:line = l:indent . '"  ' . l:content
        endif

        call setline(l:lnum, l:line)
    endfor
endfunction

" === UNIVERSAL DISPATCHERS ===
function! ToggleCommentLine()
    let l:ext = expand('%:e')
    if l:ext ==# 'xml'
        call ToggleXMLCommentLine()
    elseif l:ext ==# 'sh' || l:ext ==# 'zsh' || l:ext ==# 'py' || l:ext ==# 'zshrc'
        call ToggleBashCommentLine()
    elseif l:ext ==# 'cpp' || l:ext ==# 'h'
        call ToggleCPPCommentLine()
    elseif l:ext ==# 'vimrc' || l:ext ==# 'vim' || l:ext ==# ''
        call ToggleVIMCommentLine()
    else
        echo "Unsupported file extension: " . l:ext
    endif
endfunction

function! ToggleCommentBlock()
    let l:ext = expand('%:e')
    if l:ext ==# 'xml'
        call ToggleXMLCommentBlock()
    elseif l:ext ==# 'sh' || l:ext ==# 'zsh' || l:ext ==# 'py' || l:ext ==# 'zshrc'
        call ToggleBashCommentBlock()
    elseif l:ext ==# 'h' || l:ext ==# 'cpp'
        call ToggleCPPCommentBlock()
    elseif l:ext ==# 'vimrc' || l:ext ==# 'vim' || l:ext ==# ''
        call ToggleVIMCommentBlock()
    else
        echo "Unsupported file extension: " . l:ext
    endif
endfunction

function! ToggleComment(mode)
  let l:ext = expand('%:e')
  let l:filename = expand('%:t')
  let l:is_block = a:mode

  if l:ext ==# 'xml'
    if l:is_block
      call ToggleXMLCommentBlock()
    else
      call ToggleXMLCommentLine()
    endif
  elseif l:ext ==# 'sh' || l:ext ==# 'zsh' || l:ext ==# 'py' || l:filename ==# '.zshrc'
    if l:is_block
      call ToggleBashCommentBlock()
    else
      call ToggleBashCommentLine()
    endif
  elseif l:ext ==# 'cpp' || l:ext ==# 'h'
    if l:is_block
      call ToggleCPPCommentBlock()
    else
      call ToggleCPPCommentLine()
    endif
  elseif l:filename ==# 'vimrc' || l:ext ==# 'vim' || l:ext ==# ''
    if l:is_block
      call ToggleVIMCommentBlock()
    else
      call ToggleVIMCommentLine()
    endif
  else
    echo "Unsupported file extension: " . l:ext
  endif
endfunction

" === MAPPINGS ===
nnoremap gc :call ToggleComment(0)<CR>
vnoremap gc :<C-u>call ToggleComment(1)<CR>
