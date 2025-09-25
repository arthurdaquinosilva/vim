scriptencoding utf-8
" Behaviour carried over from tpope/vim-surround, checked against it case by
" case; the block and repeat cases are where this version deliberately differs.

" Run {keys} on {lines} with the cursor at {pos}; return the resulting lines.
function! s:Run(lines, pos, keys) abort
    call SetLines(a:lines)
    call cursor(a:pos)
    call Keys(a:keys)
    return Lines()
endfunction

function! Test_add() abort
    call assert_equal(['foo (bar) baz'], s:Run(['foo bar baz'], [1, 5], 'ysiw)'))
    call assert_equal(['foo ( bar ) baz'], s:Run(['foo bar baz'], [1, 5], 'ysiw('))
    call assert_equal(['foo [bar] baz'], s:Run(['foo bar baz'], [1, 5], 'ysiwr'))
    call assert_equal(['(ação) bar'], s:Run(['ação bar'], [1, 3], 'ysiw)'))
endfunction

function! Test_add_keeps_trailing_space_outside() abort
    call assert_equal(['foo "bar" baz'], s:Run(['foo bar baz'], [1, 5], 'ysw"'))
endfunction

function! Test_add_line() abort
    call assert_equal(['[foo bar baz]'], s:Run(['foo bar baz'], [1, 5], 'yss]'))
    call assert_equal(['  (foo bar)'], s:Run(['  foo bar'], [1, 5], 'yssb'))
endfunction

function! Test_add_linewise_motion() abort
    call assert_equal(['(', 'foo', 'bar', ')'], s:Run(['foo', 'bar'], [1, 1], 'ysj('))
    call assert_equal(['(', 'foo', ')', '', 'bar'], s:Run(['foo', '', 'bar'], [1, 1], 'ysip)'))
endfunction

function! Test_add_on_own_lines() abort
    call assert_equal(['{', '    foo', '} bar'], s:Run(['foo bar'], [1, 1], 'ySiw{'))
    call assert_equal(['  {', '      foo', '  }'], s:Run(['  foo'], [1, 3], 'ySS{'))
endfunction

function! Test_add_tag_and_function() abort
    call assert_equal(['foo <div>bar</div> baz'], s:Run(['foo bar baz'], [1, 5], "ysiwtdiv\<CR>"))
    call assert_equal(['foo <br />bar baz'], s:Run(['foo bar baz'], [1, 5], "ysiwtbr/\<CR>"))
    call assert_equal(['foo print(bar) baz'], s:Run(['foo bar baz'], [1, 5], "ysiwfprint\<CR>"))
    call assert_equal(['foo f( bar ) baz'], s:Run(['foo bar baz'], [1, 5], "ysiwFf\<CR>"))
endfunction

function! Test_add_custom() abort
    let b:surround_45 = "<% \r %>"
    call assert_equal(['<% x %>'], s:Run(['x'], [1, 1], 'ysiw-'))
endfunction

function! Test_delete() abort
    call assert_equal(['x foo y'], s:Run(['x (foo) y'], [1, 5], 'ds('))
    call assert_equal(['x foo y'], s:Run(['x ( foo ) y'], [1, 5], 'ds('))
    call assert_equal(['x  foo  y'], s:Run(['x ( foo ) y'], [1, 5], 'ds)'))
    call assert_equal(['x  foo  y'], s:Run(['x [ foo ] y'], [1, 5], 'dsr'))
    call assert_equal(['x foo y'], s:Run(['x <foo> y'], [1, 5], 'dsa'))
    call assert_equal(['x foo y'], s:Run(['x "foo" y'], [1, 5], 'ds"'))
    call assert_equal(['x foo y'], s:Run(['x `foo` y'], [1, 5], 'ds`'))
    call assert_equal(['x foo y'], s:Run(['x *foo* y'], [1, 5], 'ds*'))
    call assert_equal(['x foo y'], s:Run(['x <div class="a">foo</div> y'], [1, 19], 'dst'))
    call assert_equal(['x ação y'], s:Run(['x (ação) y'], [1, 5], 'ds('))
endfunction

function! Test_delete_missing_target_is_noop() abort
    call assert_equal(['x foo y'], s:Run(['x foo y'], [1, 4], 'ds('))
endfunction

function! Test_delete_with_count() abort
    call assert_equal(['x a (foo) b y'], s:Run(['x (a (foo) b) y'], [1, 8], 'ds2('))
    call assert_equal(['x a (foo) b y'], s:Run(['x (a (foo) b) y'], [1, 8], '2ds('))
endfunction

function! Test_delete_block() abort
    call assert_equal(['if x', '    foo'], s:Run(['if x {', '    foo', '}'], [2, 5], 'ds{'))
    call assert_equal(['f', '    a', ''], s:Run(['f(', '    a', '', ')'], [3, 1], 'ds('))
endfunction

function! Test_change() abort
    call assert_equal(["x 'foo' y"], s:Run(['x "foo" y'], [1, 5], "cs\"'"))
    call assert_equal(['x [foo] y'], s:Run(['x (foo) y'], [1, 5], 'cs)]'))
    call assert_equal(['x [ foo ] y'], s:Run(['x (foo) y'], [1, 5], 'cs)['))
    call assert_equal(['x [foo] y'], s:Run(['x ( foo ) y'], [1, 5], 'cs(]'))
    call assert_equal(['x {foo} y'], s:Run(['x (foo) y'], [1, 5], 'cs(B'))
    call assert_equal(['x _foo_ y'], s:Run(['x *foo* y'], [1, 5], 'cs*_'))
endfunction

function! Test_change_tag_keeps_attributes() abort
    let l:html = ['x <div class="a">foo</div> y']
    call assert_equal(['x <span class="a">foo</span> y'], s:Run(l:html, [1, 19], "csttspan\<CR>"))
    call assert_equal(['x <span>foo</span> y'], s:Run(l:html, [1, 19], "csttspan>\<CR>"))
    call assert_equal(['x (foo) y'], s:Run(l:html, [1, 19], 'cst)'))
endfunction

function! Test_change_block_keeps_shape() abort
    call assert_equal(['if x (', '    foo', ')'], s:Run(['if x {', '    foo', '}'], [2, 5], 'cs{('))
endfunction

function! Test_change_on_own_lines() abort
    call assert_equal(['x {', '    foo', '} y'], s:Run(['x (foo) y'], [1, 5], 'cS(B'))
endfunction

function! Test_visual() abort
    call assert_equal(['foo (bar) baz'], s:Run(['foo bar baz'], [1, 5], 'viwS)'))
    call assert_equal(['foo <em>bar</em> baz'], s:Run(['foo bar baz'], [1, 5], "viwS<em>\<CR>"))
    call assert_equal(["a'bc'", "d'ef'"], s:Run(['abc', 'def'], [1, 2], "\<C-V>jlS'"))
    call assert_equal(['  {', '      foo', '      bar', '  }'], s:Run(['  foo', '  bar'], [1, 3], 'VjS{'))
    call assert_equal(['  {', '  foo', '  }'], s:Run(['  foo'], [1, 3], 'VgS{'))
endfunction

function! Test_visual_exclusive_selection() abort
    set selection=exclusive
    call assert_equal(['foo (bar) baz'], s:Run(['foo bar baz'], [1, 5], 'vlllS)'))
endfunction

function! Test_insert() abort
    call assert_equal(['foo (z) bar'], s:Run(['foo bar'], [1, 3], "a \<C-G>s)z\<Esc>"))
    call assert_equal(['{', 'z', '}'], s:Run([''], [1, 1], "i\<C-G>S{z\<Esc>"))
endfunction

function! Test_dot_repeat() abort
    call assert_equal(['"one" "two" "three"'], s:Run(['one two three'], [1, 1], 'ysiw"W.W.'))
    call assert_equal(['a b c d e'], s:Run(['a (b) c (d) e'], [1, 4], 'ds(fdl.'))
    call assert_equal(['[a] [b]'], s:Run(['(a) (b)'], [1, 2], 'cs(]fb.'))
    call assert_equal(['<p>a</p> <p>b</p>'], s:Run(['a b'], [1, 1], "ysiwtp\<CR>W."))
endfunction

function! Test_single_undo_step() abort
    call assert_equal(['x (foo) y'], s:Run(['x (foo) y'], [1, 5], 'ds(u'))
    call assert_equal(['foo bar'], s:Run(['foo bar'], [1, 1], 'ySiw{u'))
endfunction

function! Test_escape_cancels() abort
    call assert_equal(['foo bar'], s:Run(['foo bar'], [1, 5], "ysiw\<Esc>"))
    call assert_equal(['x (foo) y'], s:Run(['x (foo) y'], [1, 5], "cs(\<Esc>"))
endfunction

function! Test_registers_untouched() abort
    call setreg('"', 'keep', 'v')
    call s:Run(['x (foo) y'], [1, 5], 'ds(')
    call s:Run(['foo'], [1, 1], 'ysiw)')
    call assert_equal('keep', getreg('"'))
endfunction
