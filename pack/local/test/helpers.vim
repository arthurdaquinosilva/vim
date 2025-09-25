scriptencoding utf-8
" pack/local/test/helpers.vim — shared helpers for the test suite.

" Fresh, single-window editor state between tests.
function! ResetEditor() abort
    silent! only!
    enew!
    silent! %bwipeout!
    set selection& virtualedit& tabstop=8 shiftwidth=4 expandtab
    set indentexpr= nocindent nosmartindent noautoindent
    unlet! g:tabular_patterns b:tabular_patterns g:tabular_default_format
endfunction

" Replace the buffer and break the undo sequence so each later edit can be
" undone on its own.
function! SetLines(lines) abort
    silent %delete _
    call setline(1, a:lines)
    let &undolevels = &undolevels
endfunction

" Run keys like a user would, with mappings.
function! Keys(keys) abort
    call feedkeys(a:keys, 'xt')
endfunction

function! Lines() abort
    return getline(1, '$')
endfunction
