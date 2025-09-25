" ~/.vim/config/functions.vim — shared helpers used by other config files.

" ── Plugin availability check ─────────────────────────────────────────────────
" Returns 1 if the named plugin was declared in _manager.vim AND its directory
" exists on disk (i.e. :PlugInstall has been run). Use this instead of
" exists(':Command') or exists('g:loaded_*'), both of which are false at vimrc
" time because plugin files haven't been sourced yet.
function! PlugLoaded(name) abort
    return has_key(get(g:, 'plugs', {}), a:name)
        \ && isdirectory(g:plugs[a:name].dir)
endfunction

" ── OSC52 yank: send the system clipboard via terminal escape sequence ───────
" Required because this Vim is built -clipboard and the host has no X display.

function! s:OSC52Yank(text) abort
    " No `-w0`: BSD base64 (macOS) lacks the flag. The substitute below strips
    " GNU's wrapped newlines, so output is single-line on both platforms.
    let l:encoded = system('base64', a:text)
    let l:encoded = substitute(l:encoded, '\n', '', 'g')
    let l:seq = "\e]52;c;" . l:encoded . "\x07"
    silent! call writefile([l:seq], '/dev/tty', 'b')
endfunction

" On Linux headless (no pbcopy): send OSC52 on every yank so the host
" terminal clipboard is updated. Skipped on macOS: native +clipboard handles it.
if !has('gui_running') && !executable('pbcopy')
    augroup osc52_yank
        autocmd!
        autocmd TextYankPost *
            \ if v:event.operator ==# 'y' |
            \   call s:OSC52Yank(join(v:event.regcontents, "\n")) |
            \ endif
    augroup END
endif

" ── Highlight other occurrences of the word under the cursor ─────────────────

function! HighlightWordUnderCursor() abort
    if getline(".")[col(".") - 1] =~# '[[:punct:][:blank:]]'
        match none
        return
    endif
    let l:word = expand('<cword>')
    if l:word == ''
        match none
        return
    endif

    " Count up to 2 — we only care whether the word appears more than once.
    let l:save = getpos(".")
    call cursor(1, 1)
    let l:count = 0
    while search('\V\<' . escape(l:word, '\') . '\>', 'W') > 0
        let l:count += 1
        if l:count > 1
            break
        endif
    endwhile
    call setpos('.', l:save)

    if l:count > 1
        execute 'match CursorWord0 /\V\<' . escape(l:word, '\') . '\>/'
    else
        match none
    endif
endfunction

augroup highlight_word_under_cursor
    autocmd!
    autocmd CursorMoved,CursorMovedI * call HighlightWordUnderCursor()
augroup END

" ── Project search: vimgrep + quickfix with friendly error handling ──────────

function! SearchAndShow() abort
    let l:term = input('Search: ')
    if empty(l:term)
        return
    endif
    let @/ = l:term
    let v:errmsg = ''
    try
        execute 'vimgrep /' . escape(l:term, '/') . '/ %'
        if v:errmsg != ''
            throw 'SearchError'
        endif
        if !empty(getqflist())
            copen
            redraw
            echo ''
        else
            throw 'NoMatches'
        endif
    catch /E480/
        redraw
        echohl WarningMsg | echo "No matches found for '" . l:term . "'" | echohl None
    catch /SearchError/
        redraw
        echohl WarningMsg | echo 'Search error: ' . v:errmsg | echohl None
    endtry
endfunction

" ── Run the current line / visual selection as a Python script ───────────────

function! ExecutePythonLine() abort
    let l:tmp = '/tmp/vim_python_exec.py'
    call writefile([getline('.')], l:tmp)
    execute '!clear && python3' l:tmp
endfunction

function! ExecutePythonVisual() range abort
    let l:tmp = '/tmp/vim_python_exec.py'
    call writefile(getline(a:firstline, a:lastline), l:tmp)
    execute '!clear && python3' l:tmp
endfunction

" ── Run the test under the cursor ────────────────────────────────────────────
" Walks back to find the enclosing class/def, then invokes the given runner.

function! s:RunTest(runner, file_expr, sep, suffix) abort
    let l:func_lnum = search('\v^\s*def \w+', 'bcnW')
    if l:func_lnum == 0
        echo 'No test function found'
        return
    endif
    let l:test_name = matchstr(getline(l:func_lnum), '\vdef \zs\w+\ze\(')
    if empty(l:test_name)
        echo 'No test found'
        return
    endif

    let l:class_pat = '\v^\s*class\s+\zs\w+\ze'
    let l:class_lnum = search(l:class_pat, 'bnW')
    let l:class_name = matchstr(getline(l:class_lnum), l:class_pat)

    let l:file = expand(a:file_expr)
    execute '!clear && ' . a:runner . ' '
        \ . l:file . a:sep . l:class_name . a:sep . l:test_name . a:suffix
endfunction

function! RunTestUnderCursor() abort
    call s:RunTest('python -m unittest', '%:t:r', '.', '')
endfunction

function! RunPytestUnderCursor() abort
    call s:RunTest('pytest', '%:p', '::', ' -v -vv -s')
endfunction
