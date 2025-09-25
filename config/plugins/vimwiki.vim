au filetype vimwiki silent! iunmap <buffer> <Tab>
au filetype vimwiki silent! iunmap <buffer> <Enter>

" Removing <Tab> from vimwiki mappings
" Core step: <Tab> and <c-i> tweak
nmap <F21> <Plug>VimwikiNextLink
nmap <F22> <Plug>VimwikiPrevLink
set wildcharm=<Tab>
cmap <F12> <c-i>
