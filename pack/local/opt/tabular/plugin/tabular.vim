vim9script
# plugin/tabular.vim — :Tabularize and :GTabularize.
# Load with `packadd tabular`; see :help tabular.

if exists('g:loaded_tabular')
    finish
endif
g:loaded_tabular = 1

command! -nargs=* -range -complete=customlist,tabular#Complete Tabularize
    \ tabular#Tabularize(<q-args>, <line1>, <line2>, <range> > 0)
command! -nargs=* -range=% -complete=customlist,tabular#Complete GTabularize
    \ tabular#Tabularize(<q-args>, <line1>, <line2>, true, true)
