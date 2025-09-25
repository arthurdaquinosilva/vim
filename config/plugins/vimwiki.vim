if !PlugLoaded('vimwiki') | finish | endif

au filetype vimwiki silent! iunmap <buffer> <Tab>
au filetype vimwiki silent! iunmap <buffer> <Enter>

" Removing <Tab> from vimwiki mappings
" Core step: <Tab> and <c-i> tweak
nmap <F21> <Plug>VimwikiNextLink
nmap <F22> <Plug>VimwikiPrevLink
set wildcharm=<Tab>
cmap <F12> <c-i>

" Align every table when a wiki/markdown buffer is first shown. vimwiki only
" formats on InsertLeave, so files written elsewhere open misaligned. Tables
" inside ``` fences are left alone. If the buffer was unmodified it stays that
" way: the alignment is only saved if you edit and write the file anyway.
function! s:FormatAllTables() abort
  if exists('b:vimwiki_tables_formatted') || !vimwiki#u#ft_is_vw() | return | endif
  let b:vimwiki_tables_formatted = 1
  let l:was_modified = &modified
  let l:view = winsaveview()
  let l:in_fence = 0
  let l:prev_row = 0
  for l:lnum in range(1, line('$'))
    let l:line = getline(l:lnum)
    if l:line =~# '^\s*```'
      let l:in_fence = !l:in_fence
    endif
    let l:is_row = !l:in_fence && l:line =~# '^\s*|.*|\s*$'
    " Format once per table, from its first row.
    if l:is_row && !l:prev_row
      call vimwiki#tbl#format(l:lnum)
    endif
    let l:prev_row = l:is_row
  endfor
  call winrestview(l:view)
  if !l:was_modified | setlocal nomodified | endif
endfunction

au BufWinEnter * call s:FormatAllTables()
