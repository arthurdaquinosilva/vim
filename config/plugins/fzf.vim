" ~/.vim/config/plugins/fzf.vim — fzf.vim configuration.

" fzf.vim is gated on ripgrep in _manager.vim; bail here too so the commands
" and mappings below don't try to call fzf#… functions when it isn't loaded.
if !executable('rg') | finish | endif

" ── Highlights ───────────────────────────────────────────────────────────────
" Transparent FZF backgrounds (Tokyo Night).

highlight FzfBg     guibg=NONE ctermbg=NONE
highlight FzfBgPlus guibg=NONE ctermbg=NONE

let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'FzfBg'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'FzfBgPlus'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Override specific highlights to keep them transparent after startup.
augroup fzf_transparent
    autocmd!
    autocmd VimEnter * highlight CursorLine   guibg=NONE ctermbg=NONE
    autocmd VimEnter * highlight CursorColumn guibg=NONE ctermbg=NONE
    autocmd VimEnter * highlight FzfBg        guibg=NONE ctermbg=NONE
    autocmd VimEnter * highlight FzfBgPlus    guibg=NONE ctermbg=NONE
augroup END

" ── Commands ─────────────────────────────────────────────────────────────────

" Quick TODO search across the project (used by <leader>td)
command! Todos :Ag TODO:

" Ripgrep helper: one function, many flag presets.
function! s:RgCmd(flags, qargs, bang) abort
    let l:cmd = 'rg --column --line-number --no-heading ' . a:flags
        \ . ' --glob "!.git/*" --color "always" ' . shellescape(a:qargs)
    let l:opts = '--multi --expect=ctrl-y --layout reverse'
        \ . ' --query ' . shellescape(a:qargs)
        \ . ' --with-nth=4.. --delimiter=":"'
    call fzf#vim#grep(l:cmd, 1,
        \ fzf#vim#with_preview({'options': l:opts, 'sink*': function('RgSink')}, 'right:50%'),
        \ a:bang)
endfunction

"                    fixed-strings  ignore-case  no-ignore  (notes)
command! -bang -nargs=* Rg   call s:RgCmd('--fixed-strings --ignore-case --no-ignore --hidden --follow', <q-args>, <bang>0)
command! -bang -nargs=* Rgi  call s:RgCmd('--fixed-strings --ignore-case --hidden --follow',             <q-args>, <bang>0)
command! -bang -nargs=* Rgic call s:RgCmd('--fixed-strings --hidden --follow',                           <q-args>, <bang>0)
command! -bang -nargs=* Rgir call s:RgCmd('--hidden --follow',                                           <q-args>, <bang>0)
command! -bang -nargs=* Rgr  call s:RgCmd('--hidden --no-ignore --follow',                               <q-args>, <bang>0)

" BLines: search inside the current buffer with the same UI/preview/sink.
command! -bang -nargs=* BLines
    \ call fzf#vim#grep(
    \   'rg --with-filename --column --line-number --no-heading --smart-case . '
    \     . fnameescape(expand('%:p')), 1,
    \   fzf#vim#with_preview({
    \     'options': '--multi --expect=ctrl-y --layout reverse --query '
    \                  . shellescape(<q-args>) . ' --with-nth=4.. --delimiter=":"',
    \     'sink*': function('RgSink')
    \   }, 'right:50%'))

" ── RgSink: ctrl-y copies; otherwise edits / populates quickfix ──────────────

function! RgSink(lines) abort
    if len(a:lines) < 2
        return
    endif
    let l:key = remove(a:lines, 0)
    if l:key == 'ctrl-y'
        let l:content = join(map(a:lines, 'split(v:val, ":")[-1]'), "\n")
        call setreg('*', l:content)
        echo 'Copied to clipboard'
        return
    endif

    let l:qf = []
    for l:line in a:lines
        let l:parts = split(l:line, ':')
        call add(l:qf, {
            \ 'filename': l:parts[0],
            \ 'lnum':     l:parts[1],
            \ 'col':      l:parts[2],
            \ 'text':     join(l:parts[3:], ':')
            \ })
    endfor
    call setqflist(l:qf, 'r')

    if len(a:lines) > 1
        copen
    else
        let l:parts = split(a:lines[0], ':')
        execute 'edit' fnameescape(l:parts[0])
        execute l:parts[1]
        execute 'normal!' l:parts[2] . '|'
    endif
endfunction

" ── Mappings ─────────────────────────────────────────────────────────────────

nnoremap <leader>ff :Files<CR>
nnoremap <leader>fa :Rgi<CR>
nnoremap <leader>l  :BLines<CR>
nnoremap <leader>b  :Buffers<CR>
nnoremap <leader>m  :Marks<CR>
nnoremap <silent> <leader>td :Todos<CR>
