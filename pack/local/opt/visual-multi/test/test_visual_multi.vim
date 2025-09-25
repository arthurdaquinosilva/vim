scriptencoding utf-8
" Visual-multi together with vim-spotlight (~/.vim/plugged/vim-spotlight).

let s:spotlight = fnamemodify(expand('<sfile>:p'), ':h:h:h:h:h:h') . '/plugged/vim-spotlight'
if isdirectory(s:spotlight)
    execute 'set runtimepath+=' . fnameescape(s:spotlight)
    execute 'source' fnameescape(s:spotlight . '/plugin/spotlight.vim')
endif

" Hand-picked colors, so cells can be told apart by their screen attributes.
highlight SpotlightDim ctermfg=232 guifg=#080808
highlight VM_Extend    ctermbg=60  guibg=#5f5f87
highlight VM_Cursor    ctermbg=33  guibg=#0087ff

function! s:quit_vm() abort
    if !empty(get(b:, 'VM_Selection', {}))
        silent! call vm#reset(1)
    endif
endfunction

" Three cursors, one per line, starting on the first line.
function! s:three_cursors() abort
    call SetLines(['alpha', 'beta', 'gamma', 'delta'])
    call cursor(1, 1)
    silent call vm#commands#add_cursor_down(0, 2)
endfunction

function! s:attr(lnum, col) abort
    redraw!
    let l:pos = screenpos(win_getid(), a:lnum, a:col)
    return screenattr(l:pos.row, l:pos.col)
endfunction

function! Test_priority_above_spotlight() abort
    let g:spotlight_priority = 100
    call assert_true(vm#hl_priority('VM_Extend') > g:spotlight_priority)
    call assert_true(vm#hl_priority('MultiCursor') > vm#hl_priority('VM_Extend'))
    let g:spotlight_priority = 200
    call assert_true(vm#hl_priority('VM_Extend') > 200)
    unlet g:spotlight_priority
endfunction

function! Test_cursors_visible_in_dimmed_text() abort
    if !exists('g:loaded_spotlight')
        return
    endif
    call s:three_cursors()
    " Light only the first line: the cursors on lines 2 and 3 sit in dim text.
    call spotlight#lines(1, 1)
    let l:dim = s:attr(4, 2)
    let l:cursor = s:attr(2, 1)
    call assert_notequal(l:dim, l:cursor, 'cursor in dimmed text is drawn dimmed')
    call assert_equal(s:attr(1, 1), l:cursor, 'cursor looks the same lit or dimmed')
    call s:quit_vm()
    call spotlight#clear()
endfunction

function! Test_selection_visible_in_dimmed_text() abort
    if !exists('g:loaded_spotlight')
        return
    endif
    call s:three_cursors()
    call spotlight#lines(1, 1)
    " Switch to extend mode and select every word to its end.
    call Keys("\<Tab>e")
    call assert_true(g:Vm.extend_mode)
    call assert_notequal(s:attr(4, 2), s:attr(2, 2), 'selection in dimmed text is drawn dimmed')
    call s:quit_vm()
    call spotlight#clear()
endfunction

function! Test_cursor_events_while_vm_active() abort
    if !exists('g:loaded_spotlight')
        return
    endif
    let g:spotlight_suppress_cursor_events = 1
    let l:ei = &eventignore
    call SetLines(['alpha', 'beta', 'gamma', 'delta'])
    call spotlight#lines(1, 2)
    call assert_match('CursorMoved', &eventignore)

    call cursor(1, 1)
    silent call vm#commands#add_cursor_down(0, 2)
    call assert_notmatch('CursorMoved', &eventignore, 'VM needs CursorMoved')
    call s:quit_vm()
    call assert_match('CursorMoved', &eventignore, 'suppression back after VM')
    call assert_equal(1, g:spotlight_suppress_cursor_events)

    call spotlight#clear()
    call assert_equal(l:ei, &eventignore)
    unlet g:spotlight_suppress_cursor_events
endfunction

function! Test_spotlight_survives_vm() abort
    if !exists('g:loaded_spotlight')
        return
    endif
    call SetLines(['alpha', 'beta', 'gamma', 'delta'])
    call spotlight#lines(2, 3)
    let l:dims = len(filter(getmatches(), 'v:val.group ==# "SpotlightDim"'))
    call cursor(2, 1)
    silent call vm#commands#add_cursor_down(0, 1)
    call Keys('Ax')
    call Keys("\<Esc>")
    call s:quit_vm()
    call assert_equal(['alpha', 'betax', 'gammax', 'delta'], Lines())
    call assert_equal(l:dims, len(filter(getmatches(), 'v:val.group ==# "SpotlightDim"')))
    call assert_equal([], filter(getmatches(), 'v:val.group =~# "^\\%(VM_Extend\\|MultiCursor\\)$"'))
    call assert_true(spotlight#is_active())
    call spotlight#clear()
endfunction
