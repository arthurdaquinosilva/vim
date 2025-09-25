let g:claude_api_key = ''

" Ensure markdown syntax is loaded
au BufNewFile,BufRead *.md set filetype=markdown

" Define markdownCodeBlock highlight group if it doesn't exist
if !hlexists("markdownCodeBlock")
  highlight link markdownCodeBlock String
endif
