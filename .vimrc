" ~/.vim/.vimrc — entry point.
" Load order: plugin manager → core → per-plugin → user commands/mappings.

" Plugin manager bootstrap and `Plug` list.
source ~/.vim/config/plugins/_manager.vim

" Core Vim options, shared functions, color scheme.
source ~/.vim/config/settings.vim
source ~/.vim/config/functions.vim
source ~/.vim/config/colorscheme.vim

" Per-plugin configuration (everything in config/plugins/ except _manager.vim).
for s:f in glob('~/.vim/config/plugins/*.vim', 0, 1)
    if s:f !~# '_manager\.vim$'
        execute 'source' fnameescape(s:f)
    endif
endfor

" User mappings last, so they can reference everything above.
source ~/.vim/config/mappings.vim

" Optional machine-local DB connections (gitignored).
if filereadable(expand('~/dadbod_databases.vim'))
    source ~/dadbod_databases.vim
endif
