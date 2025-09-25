" Default Vim Colorscheme with Flat Look
" Inspired by the flat transparent styling of Monokai configuration

set termguicolors

" Use default colorscheme but override with flat styling
colorscheme default

" Create autocommand group for default colorscheme customizations
augroup DefaultFlat
    autocmd!

    " Transparent backgrounds for main interface elements
    autocmd ColorScheme default hi Normal guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi NonText guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi EndOfBuffer guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignColumn guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi FoldColumn guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi Folded guibg=NONE ctermbg=NONE

    " Flat splits - remove background and make less intrusive
    autocmd ColorScheme default hi VertSplit guibg=NONE ctermbg=NONE guifg=#444444 ctermfg=238 gui=NONE cterm=NONE

    " Flat status line
    autocmd ColorScheme default hi StatusLine guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=NONE cterm=NONE
    autocmd ColorScheme default hi StatusLineNC guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
    autocmd ColorScheme default hi StatusLineTerm guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi StatusLineTermNC guibg=NONE ctermbg=NONE

    " Flat tabs
    autocmd ColorScheme default hi TabLine guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
    autocmd ColorScheme default hi TabLineFill guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi TabLineSel guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=bold cterm=bold

    " Line numbers with transparent background
    autocmd ColorScheme default hi LineNr guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242
    autocmd ColorScheme default hi CursorLineNr guifg=#ffffff guibg=NONE ctermbg=NONE gui=bold cterm=bold

    " Better color column - subtle instead of bright red
    autocmd ColorScheme default hi ColorColumn guibg=#2a2a2a ctermbg=235 guifg=NONE ctermfg=NONE

    " Completion menu transparency
    autocmd ColorScheme default hi Pmenu guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255
    autocmd ColorScheme default hi PmenuSel guibg=#444444 ctermbg=238 guifg=#ffffff ctermfg=255
    autocmd ColorScheme default hi PmenuSbar guibg=#333333 ctermbg=236
    autocmd ColorScheme default hi PmenuThumb guibg=#666666 ctermbg=242

    " Floating windows
    autocmd ColorScheme default hi NormalFloat guibg=#1a1a1a ctermbg=233

    " COC.NVIM integration with subtle backgrounds
    autocmd ColorScheme default hi CocPumMenu guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumSearch guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocMenuSel guibg=#444444 ctermbg=238
    autocmd ColorScheme default hi CocPum guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumSel guibg=#444444 ctermbg=238
    autocmd ColorScheme default hi CocMenu guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumFloating guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumVirtualText guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumDetail guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumShortcut guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocListLine guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocListMode guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocListPath guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi FgCocListMode guibg=NONE ctermbg=NONE

    " Remove underlines from COC diagnostic highlights and fix unused highlighting
    autocmd ColorScheme default hi CocUnusedHighlight guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocDeprecatedHighlight guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocErrorHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocWarningHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocInfoHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocHintHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocCodeLens guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocInlayHint guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

    " Subtle semantic highlighting
    autocmd ColorScheme default hi CocHighlightText guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocHighlightRead guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocHighlightWrite guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE

    " Additional CoC semantic highlighting (TypeScript/JSX specific)
    autocmd ColorScheme default hi CocSemUnusedVariable guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocSemDeprecated guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE

    " COC signs with transparent backgrounds using default colors
    autocmd ColorScheme default hi CocErrorSign guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi CocWarningSign guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi CocInfoSign guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    autocmd ColorScheme default hi CocHintSign guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46

    " Additional diagnostic signs
    autocmd ColorScheme default hi DiagnosticSignError guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi DiagnosticSignWarn guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi DiagnosticSignInfo guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    autocmd ColorScheme default hi DiagnosticSignHint guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46


    " Git integration transparency with standard colors
    autocmd ColorScheme default hi GitGutterAdd guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
    autocmd ColorScheme default hi GitGutterChange guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi GitGutterDelete guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi GitGutterChangeDelete guibg=NONE ctermbg=NONE guifg=#ff00ff ctermfg=201

    autocmd ColorScheme default hi SignifySignAdd guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignifySignChange guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignifySignDelete guibg=NONE ctermbg=NONE

    " Marks & signs transparency
    autocmd ColorScheme default hi SignatureMarkText guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignatureMarkerText guibg=NONE ctermbg=NONE

    " Better search highlighting - more subtle than default
    autocmd ColorScheme default hi Search guifg=#000000 guibg=#ffff00 ctermbg=226 ctermfg=0 gui=NONE cterm=NONE
    autocmd ColorScheme default hi IncSearch guifg=#ffffff guibg=#ff0000 ctermbg=196 ctermfg=255 gui=NONE cterm=NONE

    " Cursor line with transparent background
    autocmd ColorScheme default hi CursorLine guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

    " Word occurrence highlighting with subtle background
    autocmd ColorScheme default hi CursorWord0 guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CursorWord1 guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi WordUnderCursor guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi MatchWord guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
augroup END

" Apply the initial customizations immediately
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi FoldColumn guibg=NONE ctermbg=NONE
hi Folded guibg=NONE ctermbg=NONE

" Flat splits
hi VertSplit guibg=NONE ctermbg=NONE guifg=#444444 ctermfg=238 gui=NONE cterm=NONE

" Flat status line
hi StatusLine guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=NONE cterm=NONE
hi StatusLineNC guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
hi StatusLineTerm guibg=NONE ctermbg=NONE
hi StatusLineTermNC guibg=NONE ctermbg=NONE

" Flat tabs
hi TabLine guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
hi TabLineFill guibg=NONE ctermbg=NONE
hi TabLineSel guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=bold cterm=bold

" Line numbers with transparent background
hi LineNr guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242
hi CursorLineNr guifg=#ffffff guibg=NONE ctermbg=NONE gui=bold cterm=bold

" Better color column - subtle instead of bright red
hi ColorColumn guibg=#2a2a2a ctermbg=235 guifg=NONE ctermfg=NONE

" Completion menu transparency
hi Pmenu guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255
hi PmenuSel guibg=#444444 ctermbg=238 guifg=#ffffff ctermfg=255
hi PmenuSbar guibg=#333333 ctermbg=236
hi PmenuThumb guibg=#666666 ctermbg=242

" COC completion with subtle background for selected item
hi CocPumMenu guibg=NONE ctermbg=NONE
hi CocPumSel guibg=#444444 ctermbg=238
hi CocMenuSel guibg=#444444 ctermbg=238
hi CocPum guibg=NONE ctermbg=NONE
hi CocMenu guibg=NONE ctermbg=NONE
hi CocPumFloating guibg=NONE ctermbg=NONE

" Git signs transparency with standard colors
hi GitGutterAdd guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
hi GitGutterChange guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
hi GitGutterDelete guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
hi GitGutterChangeDelete guibg=NONE ctermbg=NONE guifg=#ff00ff ctermfg=201

" Diagnostic signs transparency with standard colors
hi CocErrorSign guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
hi CocWarningSign guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
hi CocInfoSign guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
hi CocHintSign guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46

hi DiagnosticSignError guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
hi DiagnosticSignWarn guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
hi DiagnosticSignInfo guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
hi DiagnosticSignHint guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46

hi LspDiagnosticsSignError guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
hi LspDiagnosticsSignWarning guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
hi LspDiagnosticsSignInformation guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
hi LspDiagnosticsSignHint guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46

hi ALEErrorSign guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
hi ALEWarningSign guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
hi ALEInfoSign guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51

" Better search highlighting
hi Search guifg=#000000 guibg=#ffff00 ctermbg=226 ctermfg=0 gui=NONE cterm=NONE
hi IncSearch guifg=#ffffff guibg=#ff0000 ctermbg=196 ctermfg=255 gui=NONE cterm=NONE

" Cursor line with transparent background
hi CursorLine guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

" Word occurrence highlighting with subtle background
hi CursorWord0 guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi CursorWord1 guibg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi WordUnderCursor guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi MatchWord guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE

" Subtle semantic highlighting
hi CocHighlightText guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi CocHighlightRead guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi CocHighlightWrite guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE

" CoC diagnostic and semantic highlighting fixes
hi CocUnusedHighlight guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
hi CocDeprecatedHighlight guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE
hi CocSemUnusedVariable guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
hi CocSemDeprecated guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE

" Custom
hi String gui=italic cterm=italic guifg=#ffaa00

" Remove cursor underline in NERDTree and Plug
augroup DefaultFlatCursorFix
    autocmd!
    autocmd FileType nerdtree setlocal nocursorline
    autocmd FileType nerdtree setlocal nocursorcolumn
    autocmd FileType vim-plug setlocal nocursorline
    autocmd FileType vim-plug setlocal nocursorcolumn
augroup END

" Default Vim Colorscheme with Flat Look
" Inspired by the flat transparent styling of Monokai configuration

set termguicolors

" Use default colorscheme but override with flat styling
colorscheme default

" Create autocommand group for default colorscheme customizations
augroup DefaultFlat
    autocmd!

    " Transparent backgrounds for main interface elements
    autocmd ColorScheme default hi Normal guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi NonText guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi EndOfBuffer guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignColumn guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi FoldColumn guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi Folded guibg=NONE ctermbg=NONE

    " Flat splits - remove background and make less intrusive
    autocmd ColorScheme default hi VertSplit guibg=NONE ctermbg=NONE guifg=#444444 ctermfg=238 gui=NONE cterm=NONE

    " Flat status line
    autocmd ColorScheme default hi StatusLine guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=NONE cterm=NONE
    autocmd ColorScheme default hi StatusLineNC guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
    autocmd ColorScheme default hi StatusLineTerm guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi StatusLineTermNC guibg=NONE ctermbg=NONE

    " Flat tabs
    autocmd ColorScheme default hi TabLine guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
    autocmd ColorScheme default hi TabLineFill guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi TabLineSel guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=bold cterm=bold

    " Line numbers with transparent background
    autocmd ColorScheme default hi LineNr guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242
    autocmd ColorScheme default hi CursorLineNr guifg=#ffffff guibg=NONE ctermbg=NONE gui=bold cterm=bold

    " Better color column - subtle instead of bright red
    autocmd ColorScheme default hi ColorColumn guibg=#2a2a2a ctermbg=235 guifg=NONE ctermfg=NONE

    " Completion menu transparency
    autocmd ColorScheme default hi Pmenu guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255
    autocmd ColorScheme default hi PmenuSel guibg=#444444 ctermbg=238 guifg=#ffffff ctermfg=255
    autocmd ColorScheme default hi PmenuSbar guibg=#333333 ctermbg=236
    autocmd ColorScheme default hi PmenuThumb guibg=#666666 ctermbg=242

    " Floating windows
    autocmd ColorScheme default hi NormalFloat guibg=#1a1a1a ctermbg=233

    " COC.NVIM integration with subtle backgrounds
    autocmd ColorScheme default hi CocPumMenu guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumSearch guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocMenuSel guibg=#444444 ctermbg=238
    autocmd ColorScheme default hi CocPum guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumSel guibg=#444444 ctermbg=238
    autocmd ColorScheme default hi CocMenu guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumFloating guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumVirtualText guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumDetail guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocPumShortcut guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocListLine guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocListMode guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi CocListPath guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi FgCocListMode guibg=NONE ctermbg=NONE

    " Remove underlines from COC diagnostic highlights and fix unused highlighting
    autocmd ColorScheme default hi CocUnusedHighlight guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocDeprecatedHighlight guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocErrorHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocWarningHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocInfoHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocHintHighlight guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocCodeLens guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocInlayHint guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

    " Subtle semantic highlighting
    autocmd ColorScheme default hi CocHighlightText guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocHighlightRead guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocHighlightWrite guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE

    " Additional CoC semantic highlighting (TypeScript/JSX specific)
    autocmd ColorScheme default hi CocSemUnusedVariable guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CocSemDeprecated guibg=NONE ctermbg=NONE guifg=#ffaa00 ctermfg=214 gui=NONE cterm=NONE

    " COC signs with transparent backgrounds using default colors
    autocmd ColorScheme default hi CocErrorSign guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi CocWarningSign guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi CocInfoSign guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    autocmd ColorScheme default hi CocHintSign guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46

    " Additional diagnostic signs
    autocmd ColorScheme default hi DiagnosticSignError guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi DiagnosticSignWarn guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi DiagnosticSignInfo guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    autocmd ColorScheme default hi DiagnosticSignHint guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46

    " LSP diagnostic signs
    autocmd ColorScheme default hi LspDiagnosticsSignError guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi LspDiagnosticsSignWarning guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi LspDiagnosticsSignInformation guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51
    autocmd ColorScheme default hi LspDiagnosticsSignHint guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46

    " ALE signs
    autocmd ColorScheme default hi ALEErrorSign guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi ALEWarningSign guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi ALEInfoSign guibg=NONE ctermbg=NONE guifg=#00ffff ctermfg=51

    " Git integration transparency with standard colors
    autocmd ColorScheme default hi GitGutterAdd guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
    autocmd ColorScheme default hi GitGutterChange guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
    autocmd ColorScheme default hi GitGutterDelete guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
    autocmd ColorScheme default hi GitGutterChangeDelete guibg=NONE ctermbg=NONE guifg=#ff00ff ctermfg=201

    autocmd ColorScheme default hi SignifySignAdd guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignifySignChange guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignifySignDelete guibg=NONE ctermbg=NONE

    " Marks & signs transparency
    autocmd ColorScheme default hi SignatureMarkText guibg=NONE ctermbg=NONE
    autocmd ColorScheme default hi SignatureMarkerText guibg=NONE ctermbg=NONE

    " Better search highlighting - more subtle than default
    autocmd ColorScheme default hi Search guifg=#000000 guibg=#ffff00 ctermbg=226 ctermfg=0 gui=NONE cterm=NONE
    autocmd ColorScheme default hi IncSearch guifg=#ffffff guibg=#ff0000 ctermbg=196 ctermfg=255 gui=NONE cterm=NONE

    " Cursor line with transparent background
    autocmd ColorScheme default hi CursorLine guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

    " Word occurrence highlighting with subtle background
    autocmd ColorScheme default hi CursorWord0 guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi CursorWord1 guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi WordUnderCursor guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
    autocmd ColorScheme default hi MatchWord guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
augroup END

" Apply the initial customizations immediately
hi Normal guibg=NONE ctermbg=NONE
hi NonText guibg=NONE ctermbg=NONE
hi EndOfBuffer guibg=NONE ctermbg=NONE
hi SignColumn guibg=NONE ctermbg=NONE
hi FoldColumn guibg=NONE ctermbg=NONE
hi Folded guibg=NONE ctermbg=NONE

" Flat splits
hi VertSplit guibg=NONE ctermbg=NONE guifg=#444444 ctermfg=238 gui=NONE cterm=NONE

" Flat status line
hi StatusLine guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=NONE cterm=NONE
hi StatusLineNC guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
hi StatusLineTerm guibg=NONE ctermbg=NONE
hi StatusLineTermNC guibg=NONE ctermbg=NONE

" Flat tabs
hi TabLine guibg=NONE ctermbg=NONE guifg=#888888 ctermfg=245 gui=NONE cterm=NONE
hi TabLineFill guibg=NONE ctermbg=NONE
hi TabLineSel guibg=NONE ctermbg=NONE guifg=#ffffff ctermfg=255 gui=bold cterm=bold

" Line numbers with transparent background
hi LineNr guibg=NONE ctermbg=NONE guifg=#666666 ctermfg=242
hi CursorLineNr guifg=#ffffff guibg=NONE ctermbg=NONE gui=bold cterm=bold

" Better color column - subtle instead of bright red
hi ColorColumn guibg=#2a2a2a ctermbg=235 guifg=NONE ctermfg=NONE

" Git signs transparency with standard colors
hi GitGutterAdd guibg=NONE ctermbg=NONE guifg=#00ff00 ctermfg=46
hi GitGutterChange guibg=NONE ctermbg=NONE guifg=#ffff00 ctermfg=226
hi GitGutterDelete guibg=NONE ctermbg=NONE guifg=#ff0000 ctermfg=196
hi GitGutterChangeDelete guibg=NONE ctermbg=NONE guifg=#ff00ff ctermfg=201

" Better search highlighting
hi Search guifg=#000000 guibg=#ffff00 ctermbg=226 ctermfg=0 gui=NONE cterm=NONE
hi IncSearch guifg=#ffffff guibg=#ff0000 ctermbg=196 ctermfg=255 gui=NONE cterm=NONE

" Cursor line with transparent background
hi CursorLine guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

" Word occurrence highlighting with subtle background
hi CursorWord0 guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi CursorWord1 guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi WordUnderCursor guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE
hi MatchWord guifg=NONE guibg=#444444 ctermbg=238 gui=NONE cterm=NONE

" Custom
hi String gui=italic cterm=italic guifg=#ffaa00
hi SignatureMarkText guifg=#1a1a1a
hi Folded guifg=#888888 
hi CocInlayHint guifg=#585858

" Remove cursor underline in NERDTree and Plug
augroup DefaultFlatCursorFix
    autocmd!
    autocmd FileType nerdtree setlocal nocursorline
    autocmd FileType nerdtree setlocal nocursorcolumn
    autocmd FileType vim-plug setlocal nocursorline
    autocmd FileType vim-plug setlocal nocursorcolumn
augroup END
