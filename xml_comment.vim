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
    let l:first_stripped = substitute(l:first, '^\s*', '', '')
    let l:last_stripped = substitute(l:last, '^\s*', '', '')

    if l:first_stripped =~ '^<!--' && l:last_stripped =~ '-->\s*$'
        let l:first = substitute(l:first, '<!--\s*', '', '')
        let l:last = substitute(l:last, '\s*-->\s*$', '', '')
    else
        let l:first = l:first_indent . '<!-- ' . substitute(l:first, '^\s*', '', '')
        let l:last = l:last_indent . substitute(l:last, '^\s*', '', '') . ' -->'
    endif

    call setline(l:start, l:first)
    call setline(l:end, l:last)
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

    " Capture the indentation of the first line
    let l:indent = matchstr(getline(l:start), '^\s*')

    " Check if all lines are commented
    for l:lnum in range(l:start, l:end)
        if getline(l:lnum) !~ '^\s*#'
            let l:commented = 0
            break
        endif
    endfor

    " Toggle comments
    for l:lnum in range(l:start, l:end)
        let l:line = getline(l:lnum)
        if l:commented
            " Uncomment
            let l:line = substitute(l:line, '^\s*#\s*', '', '')
        else
            " Comment
            let l:line = substitute(l:line, '^\s*', '# ', '')
        endif
        call setline(l:lnum, l:indent . l:line)
    endfor
endfunction

" === UNIVERSAL DISPATCHERS ===
function! ToggleCommentLine()
    let l:ext = expand('%:e')
    if l:ext ==# 'xml'
        call ToggleXMLCommentLine()
    elseif l:ext ==# 'sh' || l:ext ==# 'zsh' || l:ext ==# 'bash'
        call ToggleBashCommentLine()
    else
        echo "Unsupported file extension: " . l:ext
    endif
endfunction

function! ToggleCommentBlock()
    let l:ext = expand('%:e')
    if l:ext ==# 'xml'
        call ToggleXMLCommentBlock()
    elseif l:ext ==# 'sh' || l:ext ==# 'zsh' || l:ext ==# 'bash'
        call ToggleBashCommentBlock()
    else
        echo "Unsupported file extension: " . l:ext
    endif
endfunction

" === MAPPINGS ===
nnoremap gc :call ToggleCommentLine()<CR>
xnoremap gc :<C-u>call ToggleCommentBlock()<CR>
