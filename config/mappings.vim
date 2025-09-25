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

" Display translation in a window (translate.vim plugin)
if maparg('<Plug>TranslateW', 'n') !=# ''
    nmap <silent> <Leader>w <Plug>TranslateW
    vmap <silent> <Leader>w <Plug>TranslateWV
endif

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


" Search and show
nnoremap <leader>fn :vimgrep //g %<CR>:copen<CR>
nnoremap <leader>fs :call SearchAndShow()<CR>

" Remove empty lines
nnoremap <leader>re :%g/^\s*$/d<CR>
xnoremap <leader>re :g/^\s*$/d<CR>       

" Map key to translate the word under cursor to English
nnoremap <leader>te :execute '!clear && translate :en ' . expand('<cword>')<CR>
vnoremap <leader>te "zy:execute '!clear && translate :en "' . shellescape(@z) . '"'<CR>

" Map key to translate the word under cursor to Spanish
nnoremap <leader>ts :execute '!clear && translate :es ' . expand('<cword>')<CR>
vnoremap <leader>ts "zy:execute '!clear && translate :es "' . shellescape(@z) . '"'<CR>

" Map key to translate the word under cursor to Portuguese
nnoremap <leader>tp :execute '!clear && translate :pt ' . expand('<cword>')<CR>
vnoremap <leader>tp "zy:execute '!clear && translate :pt "' . shellescape(@z) . '"'<CR>


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
