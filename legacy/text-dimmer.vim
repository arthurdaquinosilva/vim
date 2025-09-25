" Text Dimmer Plugin
" <leader>h in visual mode: Toggle dimming on selection
" <leader>h in normal mode: When dim is off — operator; pair with any motion or
"                           text object (e.g. <leader>h9j, <leader>hap,
"                           <leader>hi{, <leader>hit).
"                           When dim is on — clears it.
" :Dim [range]                Dim with an ex-range (e.g. :5,20Dim, :.,+9Dim)
" :DimClear                   Clear dimming

let g:text_dimmer_coc_highlight_disabled = 0

if !exists('g:text_dimmer_buffer_states')
    let g:text_dimmer_buffer_states = {}
endif

function! s:ClearWindowMatches()
    for l:m in getmatches()
        if l:m.group ==# 'DimmedText'
            call matchdelete(l:m.id)
        endif
    endfor
endfunction

highlight DimmedText ctermfg=8 guifg=#1d1e17

" ── Buffer state ──────────────────────────────────────────────────────────────

function! s:GetState()
    let l:bufnr = bufnr('%')
    if !has_key(g:text_dimmer_buffer_states, l:bufnr)
        let g:text_dimmer_buffer_states[l:bufnr] = {
            \ 'active': 0,
            \ 'selection': []
            \ }
    endif
    return g:text_dimmer_buffer_states[l:bufnr]
endfunction

function! s:SetState(state)
    let g:text_dimmer_buffer_states[bufnr('%')] = a:state
endfunction

function! s:ClearState()
    silent! unlet g:text_dimmer_buffer_states[bufnr('%')]
endfunction

" ── Match management ─────────────────────────────────────────────────────────

function! s:AddPattern(pattern)
    call matchadd('DimmedText', a:pattern)
endfunction

function! s:ApplyPatterns(sl, sc, el, ec)
    let l:total = line('$')

    if a:sl > 1
        call s:AddPattern('\%<' . a:sl . 'l.*')
    endif
    if a:el < l:total
        call s:AddPattern('\%>' . a:el . 'l.*')
    endif

    if a:sl == a:el
        " Single line
        if a:sc > 1
            call s:AddPattern('\%' . a:sl . 'l\%<' . a:sc . 'c.')
        endif
        call s:AddPattern('\%' . a:sl . 'l\%>' . a:ec . 'c.')
    else
        " Multi-line: dim partial first and last lines
        if a:sc > 1
            call s:AddPattern('\%' . a:sl . 'l\%<' . a:sc . 'c.')
        endif
        call s:AddPattern('\%' . a:el . 'l\%>' . a:ec . 'c.')
    endif
endfunction

" ── CoC cursor-highlight suppression ─────────────────────────────────────────

function! s:DisableCoc()
    if !g:text_dimmer_coc_highlight_disabled
        let g:text_dimmer_saved_eventignore = &eventignore
        set eventignore+=CursorHold,CursorHoldI,CursorMoved,CursorMovedI
        let g:text_dimmer_coc_highlight_disabled = 1
    endif
endfunction

function! s:EnableCoc()
    if g:text_dimmer_coc_highlight_disabled
        let &eventignore = g:text_dimmer_saved_eventignore
        let g:text_dimmer_coc_highlight_disabled = 0
    endif
endfunction

" ── Core operations ───────────────────────────────────────────────────────────

function! ToggleTextDimmer() range
    if s:GetState().active
        call ClearTextDimmer()
    else
        call ApplyTextDimmer()
    endif
endfunction

function! s:ApplyAtCoords(sl, sc, el, ec)
    call ClearTextDimmer()
    call s:DisableCoc()

    " Place marks so positions track as text is edited
    call setpos("'s", [0, a:sl, a:sc, 0])
    call setpos("'e", [0, a:el, a:ec, 0])

    let l:state = s:GetState()
    let l:state.active = 1
    let l:state.selection = [a:sl, a:sc, a:el, a:ec]
    call s:SetState(l:state)

    call s:ApplyPatterns(a:sl, a:sc, a:el, a:ec)
endfunction

function! ApplyTextDimmer()
    call s:ApplyAtCoords(line("'<"), col("'<"), line("'>"), col("'>"))
endfunction

function! ApplyTextDimmerLines(line1, line2)
    let l:ec = max([1, len(getline(a:line2))])
    call s:ApplyAtCoords(a:line1, 1, a:line2, l:ec)
endfunction

function! s:DimOperator(type)
    let l:sl = line("'[")
    let l:el = line("']")
    if a:type ==# 'line'
        call ApplyTextDimmerLines(l:sl, l:el)
    else
        " char-wise (or block-wise) — use exact column bounds so the
        " delimiters of i{ / i( / it themselves end up dimmed
        call s:ApplyAtCoords(l:sl, col("'["), l:el, col("']"))
    endif
endfunction

" Smart entry point: if dim is on, clear it; otherwise start the operator.
" Prevents the double-press footgun where the second <leader>h is parsed as
" a motion inside operator-pending mode.
function! s:DimMaybeClear() abort
    if s:GetState().active
        call ClearTextDimmer()
        return ''
    endif
    let &operatorfunc = expand('<SID>') . 'DimOperator'
    return 'g@'
endfunction

function! ClearTextDimmer()
    call s:ClearWindowMatches()
    call s:ClearState()
    call s:EnableCoc()
    silent! delmarks s e
endfunction

" ── Auto-updates ─────────────────────────────────────────────────────────────

function! s:UpdateDimmer()
    let l:state = s:GetState()
    if !l:state.active
        return
    endif

    let l:sp = getpos("'s")
    let l:ep = getpos("'e")
    if l:sp[1] == 0 || l:ep[1] == 0
        return
    endif

    let l:state.selection = [l:sp[1], l:sp[2], l:ep[1], l:ep[2]]
    call s:SetState(l:state)

    call s:ClearWindowMatches()
    call s:ApplyPatterns(l:sp[1], l:sp[2], l:ep[1], l:ep[2])
endfunction

function! s:RestoreDimmer()
    " Always wipe any DimmedText matches in this window first — handles the
    " case where WinEnter fires before bufnr('%') reflects the incoming buffer,
    " causing patterns from another buffer's state to leak into this window.
    call s:ClearWindowMatches()
    let l:state = s:GetState()
    if l:state.active && len(l:state.selection) == 4
        let l:sel = l:state.selection
        call s:ApplyPatterns(l:sel[0], l:sel[1], l:sel[2], l:sel[3])
        call s:DisableCoc()
    else
        call s:EnableCoc()
    endif
endfunction

" ── Autocommands ─────────────────────────────────────────────────────────────

augroup TextDimmer
    autocmd!
    autocmd BufEnter,WinEnter * call s:RestoreDimmer()
    autocmd TextChanged,TextChangedI * call s:UpdateDimmer()
    autocmd VimLeave * silent! delmarks s e
augroup END

" ── Mappings ──────────────────────────────────────────────────────────────────

vnoremap <leader>h :<C-u>call ToggleTextDimmer()<CR>
nnoremap <silent> <expr> <leader>h <SID>DimMaybeClear()

command! -range Dim call ApplyTextDimmerLines(<line1>, <line2>)
command! DimClear call ClearTextDimmer()
