" ~/.vim/config/colorscheme.vim — theme and custom highlight overrides.

if exists('$TMUX')
    set termguicolors
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif

" Single source of truth for our highlight overrides. Re-applied on every
" ColorScheme event below, including the initial `:colorscheme tokyonight`
" call — which is why nothing has to be repeated at the top level.

function! s:ApplyFlatOverrides() abort
    " Transparent main UI
    hi Normal       guibg=NONE ctermbg=NONE
    hi NonText      guibg=NONE ctermbg=NONE
    hi EndOfBuffer  guibg=NONE ctermbg=NONE
    hi SignColumn   guibg=NONE ctermbg=NONE
    hi FoldColumn   guibg=NONE ctermbg=NONE

    " Splits, status line, tabs
    hi VertSplit        guibg=NONE ctermbg=NONE guifg=#444444 ctermfg=238 gui=NONE cterm=NONE
    hi StatusLine       guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=NONE cterm=NONE
    hi StatusLineNC     guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
    hi StatusLineTerm   guibg=NONE ctermbg=NONE
    hi StatusLineTermNC guibg=NONE ctermbg=NONE
    hi TabLine          guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
    hi TabLineFill      guibg=NONE ctermbg=NONE
    hi TabLineSel       guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=bold cterm=bold

    " Line numbers, color column
    hi LineNr       guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242
    hi CursorLineNr guifg=#ffffff guibg=NONE ctermbg=NONE gui=bold cterm=bold
    hi ColorColumn  guibg=#2a2a2a ctermbg=235 guifg=NONE ctermfg=NONE

    " Completion menus
    hi Pmenu       guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255
    hi PmenuSel    guibg=#444444 ctermbg=238 guifg=#ffffff ctermfg=255
    hi PmenuSbar   guibg=#333333 ctermbg=236
    hi PmenuThumb  guibg=#666666 ctermbg=242
    hi NormalFloat guibg=#1a1a1a ctermbg=233

    " CoC popup
    hi CocPumMenu        guibg=NONE ctermbg=NONE
    hi CocPumSearch      guibg=NONE ctermbg=NONE
    hi CocPum            guibg=NONE ctermbg=NONE
    hi CocPumSel         guibg=#444444 ctermbg=238
    hi CocMenu           guibg=NONE ctermbg=NONE
    hi CocMenuSel        guibg=#444444 ctermbg=238
    hi CocPumFloating    guibg=NONE ctermbg=NONE
    hi CocPumVirtualText guibg=NONE ctermbg=NONE
    hi CocPumDetail      guibg=NONE ctermbg=NONE
    hi CocPumShortcut    guibg=NONE ctermbg=NONE
    hi CocListLine       guibg=NONE ctermbg=NONE
    hi CocListMode       guibg=NONE ctermbg=NONE
    hi CocListPath       guibg=NONE ctermbg=NONE
    hi FgCocListMode     guibg=NONE ctermbg=NONE

    " CoC diagnostic and semantic highlights
    hi CocUnusedHighlight     guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
    hi CocDeprecatedHighlight guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE
    hi CocErrorHighlight      guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi CocWarningHighlight    guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi CocInfoHighlight       guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi CocHintHighlight       guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi CocCodeLens            guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi CocSemUnusedVariable   guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
    hi CocSemDeprecated       guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE

    " CoC reference highlights
    hi CocHighlightText  guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    hi CocHighlightRead  guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    hi CocHighlightWrite guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE

    " Diagnostic signs (CoC / LSP / ALE)
    hi CocErrorSign                  guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    hi CocWarningSign                guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    hi CocInfoSign                   guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    hi CocHintSign                   guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
    hi DiagnosticSignError           guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    hi DiagnosticSignWarn            guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    hi DiagnosticSignInfo            guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    hi DiagnosticSignHint            guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
    hi LspDiagnosticsSignError       guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    hi LspDiagnosticsSignWarning     guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    hi LspDiagnosticsSignInformation guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    hi LspDiagnosticsSignHint        guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
    hi ALEErrorSign                  guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    hi ALEWarningSign                guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    hi ALEInfoSign                   guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51

    " Git signs
    hi GitGutterAdd          guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
    hi GitGutterChange       guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    hi GitGutterDelete       guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    hi GitGutterChangeDelete guibg=NONE ctermbg=NONE guifg=#ff00ff ctermfg=201
    hi SignifySignAdd        guibg=NONE ctermbg=NONE
    hi SignifySignChange     guibg=NONE ctermbg=NONE
    hi SignifySignDelete     guibg=NONE ctermbg=NONE

    " Marks
    hi SignatureMarkText   guibg=NONE ctermbg=NONE guifg=#1a1a1a
    hi SignatureMarkerText guibg=NONE ctermbg=NONE

    " Cursor / word occurrence
    hi CursorLine      guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    hi CursorWord0     guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    hi CursorWord1     guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    hi WordUnderCursor guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    hi MatchWord       guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE

    " Search / visual
    hi Search    guibg=#3e3e3e guifg=#efefef gui=underline cterm=underline
    hi IncSearch guibg=#212121 guifg=#efefef gui=underline cterm=underline
    hi Visual    guibg=#212121 guifg=#efefef gui=underline

    " Misc tweaks
    hi String       gui=italic cterm=italic guifg=#ffaa00
    hi Folded       guibg=NONE ctermbg=NONE guifg=#888888
    hi CocInlayHint guibg=NONE ctermbg=NONE gui=NONE cterm=NONE guifg=#585858
endfunction

augroup DefaultFlat
    autocmd!
    autocmd ColorScheme * call s:ApplyFlatOverrides()
augroup END

" Triggers the ColorScheme event, which fires the augroup above.
colorscheme the-theme-without-name

" Disable cursor line/column in special buffer types.
augroup DefaultFlatCursorFix
    autocmd!
    autocmd FileType nerdtree,vim-plug setlocal nocursorline nocursorcolumn
augroup END
