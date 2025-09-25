"Buffer navigation
nnoremap <silent> <Tab> <Plug>vem_next_buffer-
nnoremap <silent> <S-Tab> <Plug>vem_prev_buffer-

" Buffer management
nnoremap <silent> <leader>bc :bp<bar>sp<bar>bn<bar>bd<CR>
nnoremap <silent> <leader>ba :w <bar> %bd <bar> e# <bar> bd# <CR>
nnoremap <silent> <leader>bq :bd!<CR>

" Utility mappings
nnoremap <silent> <leader>ht :helptags ~/.vim/doc<CR>
nnoremap <silent> <leader>nh :noh<CR>

" Display translation in a window
nmap <silent> <Leader>w <Plug>TranslateW
vmap <silent> <Leader>w <Plug>TranslateWV

" Git mappings
nnoremap <silent> <leader>gf :!clear && git-foresta \| less<CR>
nnoremap <silent> <leader>gc :!zsh -ic fshow<CR>
nnoremap <silent> <leader>gsh :!clear && git show<CR>
nnoremap <silent> <leader>gd :!clear && git diff %<CR>
nnoremap <silent> <leader>gda :!clear && git diff<CR>
nnoremap <silent> <leader>gl :vertical Git log --oneline<CR>

" Window resizing
nnoremap <silent> <Up> :resize -2<CR>
nnoremap <silent> <Down> :resize +2<CR>
nnoremap <silent> <Left> :vertical resize -2<CR>
nnoremap <silent> <Right> :vertical resize +2<CR>

" Marks management
nnoremap <silent> <leader>dm :delmarks a-zA-Z<CR>

" Paste from tmux paste-buffer (use after `tmux copy-mode → y`).
" Native p/P remain untouched so linewise/characterwise yanks behave normally.
nnoremap <silent> <leader>p :let @"=system('tmux show-buffer')<CR>""p
nnoremap <silent> <leader>P :let @"=system('tmux show-buffer')<CR>""P

" Search and show
nnoremap <leader>fn :vimgrep //g %<CR>:copen<CR>
nnoremap <leader>fs :call SearchAndShow()<CR>

" Remove empty lines
nnoremap <leader>re :%g/^\s*$/d<CR>
xnoremap <leader>re :g/^\s*$/d<CR>       

" Map key to translate the word under cursor to English
nnoremap <leader>te :execute '!clear && translatetoen ' . expand('<cword>')<CR>
vnoremap <leader>te "zy:execute '!clear && translatetoen "' . shellescape(@z) . '"'<CR>

" Map key to translate the word under cursor to Spanish
nnoremap <leader>ts :execute '!clear && translatetoes ' . expand('<cword>')<CR>
vnoremap <leader>ts "zy:execute '!clear && translatetoes "' . shellescape(@z) . '"'<CR>

" Map key to translate the word under cursor to Portuguese
nnoremap <leader>tp :execute '!clear && translatetopt ' . expand('<cword>')<CR>
vnoremap <leader>tp "zy:execute '!clear && translatetopt "' . shellescape(@z) . '"'<CR>


" Run python code directly from vim
nnoremap <leader>rp :call ExecutePythonLine()<CR>
xnoremap <leader>rp :call ExecutePythonVisual()<CR>
nnoremap <leader>rf :!clear && python3 %<CR>

" Run python test under cursor
nnoremap <leader>ur :call RunTestUnderCursor()<CR>
nnoremap <leader>uf :!clear && python -m unittest %<CR>

" Update Plugins in Vim
nnoremap <leader>up :PlugUpdate<CR>

" Prep step: let Vim change its title-string when in Normal mode (with limitation)
" Will update the trailing `n` to `i` when switched from normal mode to insert mode.
setglobal titlestring=%F\ %{v:servername}\ %{mode()}

nnoremap <leader>rc :!clear && clang++ -std=c++17 % -o %:r && ./%:r<CR>
