" Text Dimmer Plugin
" <leader>h in visual mode: Toggle dimming on selection
" <leader>h in normal mode: Clear dimming

let g:text_dimmer_coc_highlight_disabled = 0

if !exists('g:text_dimmer_buffer_states')
    let g:text_dimmer_buffer_states = {}
endif

highlight DimmedText ctermfg=8 guifg=#1d1e17

" ── Buffer state ──────────────────────────────────────────────────────────────

function! s:GetState()
    let l:bufnr = bufnr('%')
    if !has_key(g:text_dimmer_buffer_states, l:bufnr)
        let g:text_dimmer_buffer_states[l:bufnr] = {
            \ 'active': 0,
            \ 'selection': [],
            \ 'match_ids': []
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

" ── Match management (targeted — never wipes foreign matches) ─────────────────

function! s:AddPattern(pattern)
    let l:state = s:GetState()
    let l:id = matchadd('DimmedText', a:pattern)
    call add(l:state.match_ids, l:id)
    call s:SetState(l:state)
endfunction

function! s:DeleteMatches()
    let l:state = s:GetState()
    for l:id in get(l:state, 'match_ids', [])
        silent! call matchdelete(l:id)
    endfor
    let l:state.match_ids = []
    call s:SetState(l:state)
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

function! ApplyTextDimmer()
    call ClearTextDimmer()
    call s:DisableCoc()

    let l:sl = line("'<")
    let l:el = line("'>")
    let l:sc = col("'<")
    let l:ec = col("'>")

    " Place marks so positions track as text is edited
    call setpos("'s", [0, l:sl, l:sc, 0])
    call setpos("'e", [0, l:el, l:ec, 0])

    let l:state = s:GetState()
    let l:state.active = 1
    let l:state.selection = [l:sl, l:sc, l:el, l:ec]
    call s:SetState(l:state)

    call s:ApplyPatterns(l:sl, l:sc, l:el, l:ec)
endfunction

function! ClearTextDimmer()
    call s:DeleteMatches()
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

    " Update stored selection to the current mark positions
    let l:state.selection = [l:sp[1], l:sp[2], l:ep[1], l:ep[2]]
    call s:SetState(l:state)

    call s:DeleteMatches()
    call s:ApplyPatterns(l:sp[1], l:sp[2], l:ep[1], l:ep[2])
endfunction

function! s:RestoreDimmer()
    let l:state = s:GetState()
    if l:state.active && len(l:state.selection) == 4
        " Match IDs are window-local — clear stale IDs and reapply fresh
        for l:id in get(l:state, 'match_ids', [])
            silent! call matchdelete(l:id)
        endfor
        let l:state.match_ids = []
        call s:SetState(l:state)

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
nnoremap <leader>h :call ClearTextDimmer()<CR>
