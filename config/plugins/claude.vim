" vim-claude — Claude Code chat panel (:help claude).
" <Leader>c is taken by coc's CocList commands, so use <Leader>i.
let g:claude_map_prefix = '<Leader>i'
let g:markdown_fenced_languages = get(g:, 'markdown_fenced_languages',
    \ ['python', 'javascript', 'typescript', 'sh', 'vim', 'json', 'sql'])
