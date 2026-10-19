scriptencoding utf-8
" pack/local/test/run.vim — dependency-free test runner for the local packages.
"
"   vim -Nu NONE -i NONE -n --not-a-term -S pack/local/test/run.vim </dev/null
"
" Adds every package under pack/local/opt, sources each opt/*/test/test_*.vim
" and runs its Test_* functions in a fresh buffer (only those matching the
" regex $LOCAL_TEST_FILTER, when set). Writes a TAP report to $LOCAL_TEST_LOG
" (default pack/local/test/results.tap) and exits non-zero when anything
" fails. `make -C pack/local test` wraps all of this.

set noswapfile nobackup nowritebackup hidden
set shortmess+=I
let s:root = fnamemodify(expand('<sfile>:p'), ':h:h')
let &packpath = fnamemodify(s:root, ':h:h') . ',' . &packpath
filetype off
syntax off

for s:pack in glob(s:root . '/opt/*', 0, 1)
    execute 'packadd' fnamemodify(s:pack, ':t')
endfor
execute 'source' fnameescape(s:root . '/test/helpers.vim')

" Runs during startup (from -S), not on VimEnter: without a terminal on stdin
" Vim may hit EOF and quit before VimEnter fires.
function! s:run() abort
    let l:log = empty($LOCAL_TEST_LOG) ? s:root . '/test/results.tap' : $LOCAL_TEST_LOG
    let l:out = []
    let l:failed = 0
    let l:count = 0

    for l:file in sort(glob(s:root . '/opt/*/test/test_*.vim', 0, 1))
        let l:before = split(execute('function /^Test_'), "\n")
        execute 'source' fnameescape(l:file)
        let l:names = filter(split(execute('function /^Test_'), "\n"),
            \ 'index(l:before, v:val) < 0')
        let l:names = sort(map(l:names, 'matchstr(v:val, ''Test_\w\+'')'))
        if !empty($LOCAL_TEST_FILTER)
            call filter(l:names, 'v:val =~# $LOCAL_TEST_FILTER')
        endif
        call add(l:out, '# ' . fnamemodify(l:file, ':h:h:t') . '/' . fnamemodify(l:file, ':t'))

        for l:name in l:names
            let l:count += 1
            " Written before each test so a crash or hang names the culprit.
            call writefile(l:out + ['# running ' . l:name], l:log)
            let v:errors = []
            call ResetEditor()
            try
                call call(l:name, [])
            catch
                call add(v:errors, 'Exception: ' . v:exception . ' @ ' . v:throwpoint)
            endtry
            if empty(v:errors)
                call add(l:out, 'ok ' . l:count . ' - ' . l:name)
            else
                let l:failed += 1
                call add(l:out, 'not ok ' . l:count . ' - ' . l:name)
                call extend(l:out, map(copy(v:errors), '"#   " . v:val'))
            endif
            execute 'delfunction' l:name
        endfor
    endfor

    call insert(l:out, '1..' . l:count)
    call insert(l:out, '# Vim ' . (v:version / 100) . '.' . (v:version % 100))
    call add(l:out, printf('# %d/%d passed', l:count - l:failed, l:count))
    call writefile(l:out, l:log)

    if l:failed || l:count == 0
        cquit!
    endif
    qall!
endfunction

call s:run()
