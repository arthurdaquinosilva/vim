" ~/.vim/after/ftplugin/markdown.vim — markdown-specific settings & tools.

" setlocal (not set): keep these scoped to the buffer so they don't leak into
" whatever file you edit next.
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal tabstop=2

" ── Table of contents generator ──────────────────────────────────────────────
" <leader>tc rebuilds a linked TOC of every sub-header (H2 through H6), nested
" by depth. The H1 stays the document title and isn't listed. The TOC lives
" between <!-- TOC --> / <!-- /TOC --> markers: the first run inserts it after
" the H1, later runs replace it in place, so it's safe to re-run.

" Buffer-local: <leader>tc only exists while a markdown buffer is focused.
nnoremap <buffer> <silent> <leader>tc :call <SID>GenerateTOC()<CR>

" This file is re-sourced for every markdown buffer; define the functions once.
if exists('*s:GenerateTOC')
    finish
endif

" GitHub-style anchor: trim, lowercase, drop punctuation, spaces to hyphens.
function s:Slug(title) abort
    let l:slug = tolower(trim(a:title))
    let l:slug = substitute(l:slug, '[^[:alnum:] _-]', '', 'g')
    return substitute(l:slug, ' ', '-', 'g')
endfunction

function s:GenerateTOC() abort
    let l:view = winsaveview()
    let l:lines = getline(1, '$')

    " Collect H2–H6 headers, skipping anything inside a ``` fenced code block.
    " The leading-hash count gives the level; indent each entry two spaces per
    " level below H2 so deeper headers nest under their parents.
    let l:toc = []
    let l:in_fence = 0
    for l:line in l:lines
        if l:line =~# '^```'
            let l:in_fence = !l:in_fence
        elseif !l:in_fence && l:line =~# '^#\{2,6}\s\+\S'
            let l:level = strlen(matchstr(l:line, '^#\+'))
            let l:title = trim(substitute(l:line, '^#\+\s\+', '', ''))
            let l:indent = repeat('  ', l:level - 2)
            call add(l:toc, l:indent . '- [' . l:title . '](#' . s:Slug(l:title) . ')')
        endif
    endfor

    if empty(l:toc)
        echohl WarningMsg | echo 'No sub-headers (H2–H6) found' | echohl None
        return
    endif

    " match() is 0-based over the list; buffer lines are 1-based.
    let l:start = match(l:lines, '^<!-- TOC -->$')
    let l:end   = match(l:lines, '^<!-- /TOC -->$')
    let l:block = ['<!-- TOC -->'] + l:toc + ['<!-- /TOC -->']

    if l:start >= 0 && l:end > l:start
        " Existing TOC: replace the old block in place.
        silent execute (l:start + 1) . ',' . (l:end + 1) . 'delete _'
        call append(l:start, l:block)
    else
        " First run: anchor the TOC right after the H1.
        let l:h1 = match(l:lines, '^#\s\+\S')
        if l:h1 < 0
            echohl WarningMsg | echo 'No H1 header to anchor the TOC to' | echohl None
            return
        endif
        call append(l:h1 + 1, [''] + l:block + [''])
    endif

    call winrestview(l:view)
endfunction
