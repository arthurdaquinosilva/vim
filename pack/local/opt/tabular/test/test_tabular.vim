scriptencoding utf-8
" Behaviour carried over from godlygeek/tabular.

function! Test_split_delim() abort
    let l:Split = function('tabular#SplitDelim')
    let l:assign = '[|&+*/%<>=!~-]\@<!\([<>!=]=\|=\~\)\@![|&+*/%<>=!~-]*='
    call assert_equal(['a', '+=', 'b'], l:Split('a+=b', l:assign))
    call assert_equal(['a!=b'], l:Split('a!=b', l:assign))
    call assert_equal(['a', '=', 'b', '=', 'c'], l:Split('a=b=c', l:assign))
    call assert_equal(['ab', '  ', '', '  ', 'c'], l:Split('ab    c', '  '))
    call assert_equal(['a', '?', 'b', ':', 'c'], l:Split('a?b:c', '^.\{-}\zs?\|:'))
    call assert_equal(['x', '/*', 'foo', '*/', ''], l:Split('x/*foo*/', '\/\*\|\*\/\|\/\/'))
    call assert_equal(['#', 'ab', '#', 'cd', '#', 'ef', ''], l:Split('#ab#cd#ef', '[^#]*'))
    call assert_equal(['#', '', 'ab#', '', 'cd#', '', 'ef'], l:Split('#ab#cd#ef', '#\zs'))
endfunction

function! Test_parse_pattern() abort
    call assert_equal(['=', ''], tabular#ParsePattern('/='))
    call assert_equal(['=', 'l1r0'], tabular#ParsePattern('/=/l1r0'))
    call assert_equal(['a/b', 'c0'], tabular#ParsePattern('/a/b/c0'))
    call assert_equal(['a\/l1', ''], tabular#ParsePattern('/a\/l1'))
endfunction

function! Test_default_left_align() abort
    call SetLines(['a = 1', 'bbb = 22', 'cc=3'])
    1,3Tabularize /=
    call assert_equal(['a   = 1', 'bbb = 22', 'cc  = 3'], Lines())
endfunction

function! Test_formats_cycle() abort
    call SetLines(['a,bb,c', 'aaa,b,cc'])
    %Tabularize /,/r0l1
    call assert_equal(['  a, bb,  c', 'aaa,  b, cc'], Lines())
    call SetLines(['a|b', 'aaa|b'])
    %Tabularize /|/c0
    call assert_equal([' a |b', 'aaa|b'], Lines())
endfunction

function! Test_common_indent_kept() abort
    call SetLines(['    x: 1', '      long: 2'])
    %Tabularize /:/l0l1
    call assert_equal(['    x   : 1', '    long: 2'], Lines())
endfunction

function! Test_no_range_aligns_matching_block() abort
    call SetLines(['skip', 'a = 1', 'bb = 2', 'also skip', 'ccc = 3'])
    call cursor(3, 1)
    Tabularize /=
    call assert_equal(['skip', 'a  = 1', 'bb = 2', 'also skip', 'ccc = 3'], Lines())
endfunction

function! Test_no_args_repeats_last() abort
    call SetLines(['a:1', 'bb:2'])
    %Tabularize /:/l0
    call SetLines(['x:1', 'yyy:2'])
    %Tabularize
    call assert_equal(['x  :1', 'yyy:2'], Lines())
endfunction

function! Test_gtabularize_leaves_other_lines() abort
    call SetLines(['a = 1', '-- long comment line', 'bbbb = 2'])
    GTabularize /=
    call assert_equal(['a    = 1', '-- long comment line', 'bbbb = 2'], Lines())
endfunction

function! Test_named_patterns() abort
    call SetLines(['x += 1', 'long == 2', 'yy = 3'])
    %Tabularize assignment
    call assert_equal(['x         += 1', 'long == 2', 'yy         = 3'], Lines())
    call SetLines(['a     b', 'ccc   d'])
    %Tabularize multiple_spaces
    call assert_equal(['a    b', 'ccc  d'], Lines())
    let g:tabular_patterns = {'colon': '/:/l0l1'}
    call SetLines(['k:v', 'key:v'])
    %Tabularize colon
    call assert_equal(['k  : v', 'key: v'], Lines())
endfunction

function! Test_multibyte_width() abort
    call SetLines(['ção = 1', 'x = 2'])
    %Tabularize /=
    call assert_equal(['ção = 1', 'x   = 2'], Lines())
endfunction

function! Test_single_undo_step() abort
    call SetLines(['a=1', 'bbb=2'])
    %Tabularize /=
    undo
    call assert_equal(['a=1', 'bbb=2'], Lines())
endfunction
