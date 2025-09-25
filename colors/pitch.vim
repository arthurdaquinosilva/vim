" ~/.vim/colors/pitch.vim — cool blue/violet hues on a pitch-black terminal.
"
" Backgrounds are NONE so the terminal's own #000000 shows through; only
" Visual selections, search matches and diffs paint a surface. The same
" palette is used by tmux, fzf, bat, lazygit, lazydocker, git and the prompt
" (see ~/dotfiles/terminal/colors/pitch.md).

set background=dark
hi clear
if exists('syntax_on')
    syntax reset
endif
let g:colors_name = 'pitch'

" Palette: [gui, cterm]
let s:none    = ['NONE',    'NONE']
let s:bg1     = ['#0b0d14', 233]
let s:bg2     = ['#161925', 234]
let s:bg3     = ['#232738', 235]
let s:border  = ['#2a2e42', 237]
let s:gutter  = ['#3b4261', 239]
let s:comment = ['#565f89', 60]
let s:fg_dim  = ['#a9b1d6', 146]
let s:fg      = ['#c0caf5', 153]
let s:blue    = ['#7aa2f7', 111]
let s:cyan    = ['#7dcfff', 117]
let s:teal    = ['#73daca', 80]
let s:green   = ['#9ece6a', 149]
let s:yellow  = ['#e0af68', 179]
let s:orange  = ['#ff9e64', 215]
let s:red     = ['#f7768e', 210]
let s:magenta = ['#bb9af7', 141]
let s:add_bg  = ['#0e2016', 22]
let s:del_bg  = ['#250c12', 52]
let s:chg_bg  = ['#0d1830', 17]
let s:txt_bg  = ['#1d3260', 24]

" s:hi(group, fg, bg, [attr], [sp])
function! s:hi(group, fg, bg, ...) abort
    let l:attr = a:0 >= 1 ? a:1 : 'NONE'
    let l:sp   = a:0 >= 2 ? a:2 : s:none
    execute 'hi' a:group
        \ 'guifg=' . a:fg[0] 'ctermfg=' . a:fg[1]
        \ 'guibg=' . a:bg[0] 'ctermbg=' . a:bg[1]
        \ 'gui=' . l:attr 'cterm=' . l:attr
        \ 'guisp=' . l:sp[0]
endfunction

" ── Editor UI ────────────────────────────────────────────────────────────────
call s:hi('Normal',       s:fg,      s:none)
call s:hi('NormalFloat',  s:fg,      s:none)
call s:hi('NonText',      s:gutter,  s:none)
call s:hi('EndOfBuffer',  s:bg3,     s:none)
call s:hi('SpecialKey',   s:gutter,  s:none)
call s:hi('Whitespace',   s:border,  s:none)
call s:hi('Conceal',      s:comment, s:none)
call s:hi('LineNr',       s:gutter,  s:none)
call s:hi('LineNrAbove',  s:gutter,  s:none)
call s:hi('LineNrBelow',  s:gutter,  s:none)
call s:hi('CursorLineNr', s:fg,      s:none, 'bold')
call s:hi('CursorLine',   s:none,    s:none)
call s:hi('CursorColumn', s:none,    s:bg1)
call s:hi('ColorColumn',  s:none,    s:bg1)
call s:hi('SignColumn',   s:fg_dim,  s:none)
call s:hi('FoldColumn',   s:comment, s:none)
call s:hi('Folded',       s:comment, s:none)
call s:hi('VertSplit',    s:border,  s:none)
call s:hi('VertSplitNC',  s:border,  s:none)
call s:hi('StatusLine',   s:fg,      s:none)
call s:hi('StatusLineNC', s:comment, s:none)
call s:hi('StatusLineTerm',   s:fg,      s:none)
call s:hi('StatusLineTermNC', s:comment, s:none)
call s:hi('TabLine',      s:comment, s:none)
call s:hi('TabLineFill',  s:none,    s:none)
call s:hi('TabLineSel',   s:fg,      s:none, 'bold')
call s:hi('WildMenu',     s:blue,    s:none, 'bold')
call s:hi('Title',        s:blue,    s:none, 'bold')
call s:hi('Directory',    s:blue,    s:none)
call s:hi('MatchParen',   s:orange,  s:none, 'bold')
call s:hi('Visual',       s:none,    s:bg2)
call s:hi('VisualNOS',    s:none,    s:bg2)
call s:hi('Search',       s:none,    s:bg3)
call s:hi('CurSearch',    s:fg,      s:bg3, 'bold,underline')
call s:hi('IncSearch',    s:fg,      s:bg3, 'underline')
call s:hi('QuickFixLine', s:blue,    s:none, 'bold')
call s:hi('ModeMsg',      s:comment, s:none)
call s:hi('MoreMsg',      s:blue,    s:none)
call s:hi('Question',     s:blue,    s:none)
call s:hi('ErrorMsg',     s:red,     s:none, 'bold')
call s:hi('WarningMsg',   s:yellow,  s:none)
call s:hi('ToolbarLine',  s:fg,      s:none)
call s:hi('ToolbarButton', s:blue,    s:none, 'bold')

" Popup menu
call s:hi('Pmenu',        s:fg_dim,  s:none)
call s:hi('PmenuSel',     s:blue,    s:none, 'bold')
call s:hi('PmenuKind',    s:magenta, s:none)
call s:hi('PmenuKindSel', s:magenta, s:none, 'bold')
call s:hi('PmenuExtra',   s:comment, s:none)
call s:hi('PmenuExtraSel', s:fg_dim, s:none)
call s:hi('PmenuMatch',   s:blue,    s:none, 'bold')
call s:hi('PmenuMatchSel', s:cyan,   s:none, 'bold')
call s:hi('PmenuSbar',    s:none,    s:bg1)
call s:hi('PmenuThumb',   s:none,    s:border)

" Spelling
call s:hi('SpellBad',     s:none, s:none, 'undercurl', s:red)
call s:hi('SpellCap',     s:none, s:none, 'undercurl', s:yellow)
call s:hi('SpellLocal',   s:none, s:none, 'undercurl', s:cyan)
call s:hi('SpellRare',    s:none, s:none, 'undercurl', s:magenta)

" Diff
call s:hi('DiffAdd',      s:none,    s:add_bg)
call s:hi('DiffDelete',   s:red,     s:del_bg)
call s:hi('DiffChange',   s:none,    s:chg_bg)
call s:hi('DiffText',     s:none,    s:txt_bg)
call s:hi('Added',        s:green,   s:none)
call s:hi('Changed',      s:yellow,  s:none)
call s:hi('Removed',      s:red,     s:none)
call s:hi('diffAdded',    s:green,   s:none)
call s:hi('diffRemoved',  s:red,     s:none)
call s:hi('diffChanged',  s:yellow,  s:none)
call s:hi('diffFile',     s:blue,    s:none, 'bold')
call s:hi('diffLine',     s:magenta, s:none)
call s:hi('diffIndexLine', s:comment, s:none)

" ── Syntax ───────────────────────────────────────────────────────────────────
call s:hi('Comment',      s:comment, s:none, 'italic')
call s:hi('Constant',     s:orange,  s:none)
call s:hi('String',       s:green,   s:none)
call s:hi('Character',    s:green,   s:none)
call s:hi('Number',       s:orange,  s:none)
call s:hi('Boolean',      s:orange,  s:none)
call s:hi('Float',        s:orange,  s:none)
call s:hi('Identifier',   s:fg,      s:none)
call s:hi('Function',     s:blue,    s:none)
call s:hi('Statement',    s:magenta, s:none)
call s:hi('Conditional',  s:magenta, s:none)
call s:hi('Repeat',       s:magenta, s:none)
call s:hi('Label',        s:blue,    s:none)
call s:hi('Operator',     s:cyan,    s:none)
call s:hi('Keyword',      s:magenta, s:none)
call s:hi('Exception',    s:magenta, s:none)
call s:hi('PreProc',      s:cyan,    s:none)
call s:hi('Include',      s:cyan,    s:none)
call s:hi('Define',       s:magenta, s:none)
call s:hi('Macro',        s:cyan,    s:none)
call s:hi('PreCondit',    s:cyan,    s:none)
call s:hi('Type',         s:teal,    s:none)
call s:hi('StorageClass', s:magenta, s:none)
call s:hi('Structure',    s:teal,    s:none)
call s:hi('Typedef',      s:teal,    s:none)
call s:hi('Special',      s:cyan,    s:none)
call s:hi('SpecialChar',  s:cyan,    s:none)
call s:hi('Tag',          s:red,     s:none)
call s:hi('Delimiter',    s:fg_dim,  s:none)
call s:hi('SpecialComment', s:comment, s:none, 'bold')
call s:hi('Debug',        s:orange,  s:none)
call s:hi('Underlined',   s:blue,    s:none, 'underline')
call s:hi('Ignore',       s:border,  s:none)
call s:hi('Error',        s:red,     s:none, 'bold')
call s:hi('Todo',         s:yellow,  s:none, 'bold')

" Markup (markdown, help, vimwiki via html*)
call s:hi('helpHyperTextJump', s:blue,    s:none, 'underline')
call s:hi('helpOption',        s:cyan,    s:none)
call s:hi('markdownH1',        s:blue,    s:none, 'bold')
call s:hi('markdownH2',        s:magenta, s:none, 'bold')
call s:hi('markdownH3',        s:cyan,    s:none, 'bold')
call s:hi('markdownCode',      s:teal,    s:none)
call s:hi('markdownCodeBlock', s:teal,    s:none)
call s:hi('markdownUrl',       s:blue,    s:none, 'underline')
call s:hi('markdownLinkText',  s:cyan,    s:none)
call s:hi('htmlH1',            s:blue,    s:none, 'bold')
call s:hi('htmlH2',            s:magenta, s:none, 'bold')
call s:hi('htmlH3',            s:cyan,    s:none, 'bold')
call s:hi('htmlH4',            s:teal,    s:none, 'bold')
call s:hi('htmlBold',          s:fg,      s:none, 'bold')
call s:hi('htmlItalic',        s:fg,      s:none, 'italic')
call s:hi('htmlTagName',       s:red,     s:none)
call s:hi('htmlArg',           s:yellow,  s:none)
call s:hi('VimwikiLink',       s:blue,    s:none, 'underline')
call s:hi('VimwikiCode',       s:teal,    s:none)

" ── Diagnostics / LSP (CoC) ──────────────────────────────────────────────────
call s:hi('CocErrorSign',        s:red,     s:none)
call s:hi('CocWarningSign',      s:yellow,  s:none)
call s:hi('CocInfoSign',         s:cyan,    s:none)
call s:hi('CocHintSign',         s:teal,    s:none)
call s:hi('CocErrorVirtualText', s:red,     s:none)
call s:hi('CocWarningVirtualText', s:yellow, s:none)
call s:hi('CocInfoVirtualText',  s:cyan,    s:none)
call s:hi('CocHintVirtualText',  s:teal,    s:none)
call s:hi('CocErrorHighlight',   s:none, s:none, 'undercurl', s:red)
call s:hi('CocWarningHighlight', s:none, s:none, 'undercurl', s:yellow)
call s:hi('CocInfoHighlight',    s:none, s:none, 'undercurl', s:cyan)
call s:hi('CocHintHighlight',    s:none, s:none, 'undercurl', s:teal)
call s:hi('CocUnusedHighlight',  s:comment, s:none)
call s:hi('CocDeprecatedHighlight', s:comment, s:none, 'strikethrough')
call s:hi('CocSemUnusedVariable', s:comment, s:none)
call s:hi('CocSemDeprecated',    s:comment, s:none, 'strikethrough')
call s:hi('CocInlayHint',        s:gutter,  s:none)
call s:hi('CocCodeLens',         s:gutter,  s:none)
call s:hi('CocFadeOut',          s:comment, s:none)
call s:hi('CocHighlightText',    s:none,    s:bg3)
call s:hi('CocHighlightRead',    s:none,    s:bg3)
call s:hi('CocHighlightWrite',   s:none,    s:bg3)
call s:hi('CocFloating',         s:fg,      s:none)
call s:hi('CocFloatBorder',      s:border,  s:none)
call s:hi('CocFloatThumb',       s:none,    s:border)
call s:hi('CocFloatSbar',        s:none,    s:bg1)
call s:hi('CocMenuSel',          s:blue,    s:none, 'bold')
call s:hi('CocPumSearch',        s:blue,    s:none, 'bold')
call s:hi('CocPumDetail',        s:comment, s:none)
call s:hi('CocPumShortcut',      s:comment, s:none)
call s:hi('CocPumVirtualText',   s:gutter,  s:none)
call s:hi('CocSearch',           s:blue,    s:none, 'bold')
call s:hi('CocListLine',         s:blue,    s:none, 'bold')
call s:hi('CocListMode',         s:fg,      s:none, 'bold')
call s:hi('CocListPath',         s:comment, s:none)
call s:hi('CocListSearch',       s:blue,    s:none, 'bold')
hi! link DiagnosticSignError CocErrorSign
hi! link DiagnosticSignWarn  CocWarningSign
hi! link DiagnosticSignInfo  CocInfoSign
hi! link DiagnosticSignHint  CocHintSign
hi! link ALEErrorSign        CocErrorSign
hi! link ALEWarningSign      CocWarningSign
hi! link ALEInfoSign         CocInfoSign

" ── Plugins ──────────────────────────────────────────────────────────────────
" gitgutter / signify
call s:hi('GitGutterAdd',          s:green,   s:none)
call s:hi('GitGutterChange',       s:yellow,  s:none)
call s:hi('GitGutterDelete',       s:red,     s:none)
call s:hi('GitGutterChangeDelete', s:orange,  s:none)
call s:hi('GitGutterAddLine',          s:none, s:add_bg)
call s:hi('GitGutterChangeLine',       s:none, s:chg_bg)
call s:hi('GitGutterDeleteLine',       s:none, s:del_bg)
call s:hi('GitGutterChangeDeleteLine', s:none, s:chg_bg)
hi! link SignifySignAdd    GitGutterAdd
hi! link SignifySignChange GitGutterChange
hi! link SignifySignDelete GitGutterDelete

" fugitive
call s:hi('fugitiveHeader',          s:blue,    s:none, 'bold')
call s:hi('fugitiveUntrackedHeading', s:magenta, s:none, 'bold')
call s:hi('fugitiveUnstagedHeading', s:yellow,  s:none, 'bold')
call s:hi('fugitiveStagedHeading',   s:green,   s:none, 'bold')
call s:hi('fugitiveUntrackedModifier', s:magenta, s:none)
call s:hi('fugitiveUnstagedModifier', s:yellow, s:none)
call s:hi('fugitiveStagedModifier',  s:green,   s:none)
call s:hi('fugitiveHash',            s:comment, s:none)

" NERDTree
call s:hi('NERDTreeDir',       s:blue,    s:none)
call s:hi('NERDTreeDirSlash',  s:blue,    s:none)
call s:hi('NERDTreeOpenable',  s:comment, s:none)
call s:hi('NERDTreeClosable',  s:comment, s:none)
call s:hi('NERDTreeFile',      s:fg_dim,  s:none)
call s:hi('NERDTreeExecFile',  s:green,   s:none)
call s:hi('NERDTreeUp',        s:comment, s:none)
call s:hi('NERDTreeCWD',       s:magenta, s:none, 'bold')
call s:hi('NERDTreeHelp',      s:comment, s:none)
call s:hi('NERDTreeLinkTarget', s:cyan,   s:none)

" Startify
call s:hi('StartifyHeader',  s:blue,    s:none)
call s:hi('StartifySection', s:magenta, s:none, 'bold')
call s:hi('StartifyBracket', s:gutter,  s:none)
call s:hi('StartifyNumber',  s:orange,  s:none)
call s:hi('StartifyPath',    s:comment, s:none)
call s:hi('StartifySlash',   s:gutter,  s:none)
call s:hi('StartifyFile',    s:fg,      s:none)
call s:hi('StartifySpecial', s:comment, s:none)
call s:hi('StartifyFooter',  s:comment, s:none)

" vem-tabline
call s:hi('VemTablineNormal',          s:comment, s:none)
call s:hi('VemTablineLocation',        s:gutter,  s:none)
call s:hi('VemTablineNumber',          s:gutter,  s:none)
call s:hi('VemTablineSelected',        s:fg,      s:none, 'bold')
call s:hi('VemTablineLocationSelected', s:comment, s:none, 'bold')
call s:hi('VemTablineNumberSelected',  s:blue,    s:none, 'bold')
call s:hi('VemTablineShown',           s:fg_dim,  s:none)
call s:hi('VemTablineLocationShown',   s:gutter,  s:none)
call s:hi('VemTablineNumberShown',     s:gutter,  s:none)
call s:hi('VemTablineSeparator',       s:border,  s:none)
call s:hi('VemTablinePartialName',     s:comment, s:none)
call s:hi('VemTablineTabNormal',       s:comment, s:none)
call s:hi('VemTablineTabSelected',     s:fg,      s:none, 'bold')

" Motion / visual aids
call s:hi('QuickScopePrimary',      s:orange,  s:none, 'bold,underline')
call s:hi('QuickScopeSecondary',    s:cyan,    s:none, 'bold,underline')
call s:hi('HighlightedyankRegion',  s:none,    s:bg3)
call s:hi('MatchWord',              s:none,    s:bg3)
call s:hi('MatchParenCur',          s:orange,  s:none, 'bold')
call s:hi('MatchWordCur',           s:none,    s:bg3)
call s:hi('CursorWord0',            s:none,    s:bg3)
call s:hi('CursorWord1',            s:none,    s:bg3)
call s:hi('WordUnderCursor',        s:none,    s:bg3)
call s:hi('SignatureMarkText',      s:magenta, s:none)
call s:hi('SignatureMarkerText',    s:cyan,    s:none)
" vim-spotlight: dimmed text sits one step above the black background
call s:hi('SpotlightDim',           ['#080808', 232], s:none)

" vim-visual-multi
call s:hi('VM_Mono',   s:bg2,  s:magenta)
call s:hi('VM_Extend', s:none, s:bg3)
call s:hi('VM_Cursor', s:bg2,  s:blue)
call s:hi('VM_Insert', s:bg2,  s:cyan)

" dadbod-ui
call s:hi('dbui_tables',      s:fg_dim,  s:none)
call s:hi('dbui_connection_ok', s:green, s:none)
call s:hi('dbui_connection_error', s:red, s:none)

" ── :terminal ────────────────────────────────────────────────────────────────
let g:terminal_ansi_colors = [
    \ '#000000', s:red[0], s:green[0], s:yellow[0],
    \ s:blue[0], s:magenta[0], s:cyan[0], s:fg_dim[0],
    \ s:gutter[0], s:red[0], s:green[0], s:yellow[0],
    \ s:blue[0], s:magenta[0], s:cyan[0], s:fg[0]]

delfunction s:hi
