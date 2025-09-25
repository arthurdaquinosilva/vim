vim9script
# plugin/surround.vim — ds, cs, ys and friends.
# Load with `packadd surround`; see :help surround.

if exists('g:loaded_surround')
    finish
endif
g:loaded_surround = 1

nnoremap <expr> <Plug>(surround-delete)           surround#Setup('ds') .. 'l'
nnoremap <expr> <Plug>(surround-change)           surround#Setup('cs') .. 'l'
nnoremap <expr> <Plug>(surround-change-lines)     surround#Setup('cS') .. 'l'
nnoremap <expr> <Plug>(surround-add)              surround#Setup('ys')
nnoremap <expr> <Plug>(surround-add-lines)        surround#Setup('yS')
nnoremap <expr> <Plug>(surround-line)             '^' .. v:count1 .. surround#Setup('ys') .. 'g_'
nnoremap <expr> <Plug>(surround-line-lines)       surround#Setup('yS') .. '_'
xnoremap <Plug>(surround-visual)       <Esc><ScriptCmd>surround#Visual(visualmode(), visualmode() ==# 'V')<CR>
xnoremap <Plug>(surround-visual-lines) <Esc><ScriptCmd>surround#Visual(visualmode(), visualmode() !=# 'V')<CR>
inoremap <expr> <Plug>(surround-insert)           surround#Insert(false)
inoremap <expr> <Plug>(surround-insert-lines)     surround#Insert(true)

if !get(g:, 'surround_no_mappings', false)
    nmap ds  <Plug>(surround-delete)
    nmap cs  <Plug>(surround-change)
    nmap cS  <Plug>(surround-change-lines)
    nmap ys  <Plug>(surround-add)
    nmap yS  <Plug>(surround-add-lines)
    nmap yss <Plug>(surround-line)
    nmap ySs <Plug>(surround-line-lines)
    nmap ySS <Plug>(surround-line-lines)
    xmap S   <Plug>(surround-visual)
    xmap gS  <Plug>(surround-visual-lines)
    if !get(g:, 'surround_no_insert_mappings', false)
        imap <C-G>s <Plug>(surround-insert)
        imap <C-G>S <Plug>(surround-insert-lines)
    endif
endif
