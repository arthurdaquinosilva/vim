" ~/.vim/config/colorscheme.vim — theme and custom highlight overrides.

set background=dark

" Single source of truth for our highlight overrides. Re-applied on every
" ColorScheme event below, including the initial `:colorscheme` call
" — which is why nothing has to be repeated at the top level.

function! s:ApplyFlatOverrides() abort
    " Transparent main UI
    hi Normal       ctermbg=NONE
    hi NonText      ctermbg=NONE
    hi EndOfBuffer  ctermbg=NONE
    hi SignColumn   ctermbg=NONE
    hi FoldColumn   ctermbg=NONE
    hi ModeMsg     ctermbg=NONE ctermfg=245 cterm=NONE

    " Splits, status line, tabs
    hi VertSplit        ctermbg=NONE ctermfg=238 cterm=NONE
    hi StatusLine       ctermbg=NONE ctermfg=255 cterm=NONE
    hi StatusLineNC     ctermbg=NONE ctermfg=245 cterm=NONE
    hi StatusLineTerm   ctermbg=NONE
    hi StatusLineTermNC ctermbg=NONE
    hi TabLine          ctermbg=NONE ctermfg=245 cterm=NONE
    hi TabLineFill      ctermbg=NONE
    hi TabLineSel       ctermbg=NONE ctermfg=255 cterm=bold

    " Line numbers, color column
    hi LineNr       ctermbg=NONE ctermfg=242
    hi CursorLineNr ctermbg=NONE ctermfg=255 cterm=bold
    hi ColorColumn  ctermbg=235

    " Completion menus
    hi Pmenu       ctermbg=NONE ctermfg=255
    hi PmenuSel    ctermbg=238  ctermfg=255
    hi PmenuSbar   ctermbg=236
    hi PmenuThumb  ctermbg=242
    hi NormalFloat ctermbg=NONE

    " CoC popup
    hi CocPumMenu        ctermbg=NONE
    hi CocPumSearch      ctermbg=NONE
    hi CocPum            ctermbg=NONE
    hi CocPumSel         ctermbg=238
    hi CocMenu           ctermbg=NONE
    hi CocMenuSel        ctermbg=238
    hi CocPumFloating    ctermbg=NONE
    hi CocPumVirtualText ctermbg=NONE
    hi CocPumDetail      ctermbg=NONE
    hi CocPumShortcut    ctermbg=NONE
    hi CocListLine       ctermbg=NONE
    hi CocListMode       ctermbg=NONE
    hi CocListPath       ctermbg=NONE
    hi FgCocListMode     ctermbg=NONE

    " CoC diagnostic and semantic highlights
    hi CocUnusedHighlight     ctermbg=NONE ctermfg=242 cterm=NONE
    hi CocDeprecatedHighlight ctermbg=NONE ctermfg=214 cterm=NONE
    hi CocErrorHighlight      ctermbg=NONE cterm=NONE
    hi CocWarningHighlight    ctermbg=NONE cterm=NONE
    hi CocInfoHighlight       ctermbg=NONE cterm=NONE
    hi CocHintHighlight       ctermbg=NONE cterm=NONE
    hi CocCodeLens            ctermbg=NONE cterm=NONE
    hi CocSemUnusedVariable   ctermbg=NONE ctermfg=242 cterm=NONE
    hi CocSemDeprecated       ctermbg=NONE ctermfg=214 cterm=NONE
    hi CocInlayHint           ctermbg=NONE ctermfg=240 cterm=NONE

    " CoC reference highlights
    hi CocHighlightText  ctermbg=238 cterm=NONE
    hi CocHighlightRead  ctermbg=238 cterm=NONE
    hi CocHighlightWrite ctermbg=238 cterm=NONE

    " Diagnostic signs (CoC + native LSP + ALE)
    hi CocErrorSign        ctermbg=NONE ctermfg=196
    hi CocWarningSign      ctermbg=NONE ctermfg=226
    hi CocInfoSign         ctermbg=NONE ctermfg=51
    hi CocHintSign         ctermbg=NONE ctermfg=46
    hi DiagnosticSignError ctermbg=NONE ctermfg=196
    hi DiagnosticSignWarn  ctermbg=NONE ctermfg=226
    hi DiagnosticSignInfo  ctermbg=NONE ctermfg=51
    hi DiagnosticSignHint  ctermbg=NONE ctermfg=46
    hi ALEErrorSign        ctermbg=NONE ctermfg=196
    hi ALEWarningSign      ctermbg=NONE ctermfg=226
    hi ALEInfoSign         ctermbg=NONE ctermfg=51

    " Git signs
    hi GitGutterAdd          ctermbg=NONE ctermfg=46
    hi GitGutterChange       ctermbg=NONE ctermfg=226
    hi GitGutterDelete       ctermbg=NONE ctermfg=196
    hi GitGutterChangeDelete ctermbg=NONE ctermfg=201
    hi SignifySignAdd        ctermbg=NONE
    hi SignifySignChange     ctermbg=NONE
    hi SignifySignDelete     ctermbg=NONE

    " Marks
    hi SignatureMarkText   ctermbg=NONE
    hi SignatureMarkerText ctermbg=NONE

    " Cursor / word occurrence
    hi CursorLine      ctermbg=NONE cterm=NONE
    hi CursorWord0     ctermbg=238 cterm=NONE
    hi CursorWord1     ctermbg=238 cterm=NONE
    hi WordUnderCursor ctermbg=238 cterm=NONE
    hi MatchWord       ctermbg=238 cterm=NONE

    " Search / visual
    hi Search    ctermbg=238 ctermfg=NONE cterm=NONE     term=NONE
    hi IncSearch ctermbg=239 ctermfg=NONE cterm=underline term=NONE
    hi Visual    ctermbg=235 ctermfg=NONE cterm=NONE term=NONE

    " Readability fixes over default colorscheme
    hi Comment ctermfg=245 cterm=NONE
    hi Folded  ctermbg=NONE ctermfg=245
endfunction

augroup DefaultFlat
    autocmd!
    autocmd ColorScheme * call s:ApplyFlatOverrides()
augroup END

" Triggers the ColorScheme event, which fires the augroup above.
colorscheme habamax

" Disable cursor line/column in special buffer types.
augroup DefaultFlatCursorFix
    autocmd!
    autocmd FileType nerdtree,vim-plug setlocal nocursorline nocursorcolumn
augroup END
