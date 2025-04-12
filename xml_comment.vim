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
vnoremap gc :<C-u>call ToggleCommentBlock()<CR>
