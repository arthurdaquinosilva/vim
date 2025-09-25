" ~/.vim/config/colorscheme.vim — color scheme.

" Truecolor when the terminal advertises it; pitch falls back to 256 colors.
if has('termguicolors') && $COLORTERM =~# 'truecolor\|24bit'
    " tmux-256color's terminfo lacks the RGB escapes, so spell them out.
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
endif

" ~/.vim/colors/pitch.vim — the palette shared with the rest of the terminal.
colorscheme pitch

" Disable cursor line/column in special buffer types.
augroup PitchCursorFix
    autocmd!
    autocmd FileType nerdtree,vim-plug setlocal nocursorline nocursorcolumn
augroup END
