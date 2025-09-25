let s:plug_path = expand('$HOME/.vim/autoload/plug.vim')

if !filereadable(s:plug_path)
  echo 'Installing vim-plug...'
  silent !mkdir -p $HOME/.vim/autoload
  silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  execute 'source ' . fnameescape(s:plug_path)
endif

call plug#begin()

" Completion (Node-based language servers)
if executable('node')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif

" UI
Plug 'mhinz/vim-startify'
Plug 'pacha/vem-tabline'
Plug 'ghifarit53/tokyonight-vim'
Plug 'arthurdaquinosilva/the-theme-without-name'

" File navigation
Plug 'preservim/nerdtree'
Plug 'PhilRunninger/nerdtree-visual-selection'
" fzf.vim's project-search commands depend on ripgrep; skip the whole stack
" when rg isn't around (the bundled fzf installer also needs build tools we
" don't want to require on constrained machines).
if executable('rg')
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
endif

" Editing
Plug 'jiangmiao/auto-pairs'
Plug 'godlygeek/tabular'
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'
Plug 'matze/vim-move'
Plug 'mg979/vim-visual-multi'

" Motion / visual aids
Plug 'vimoxide/vim-quickscope'
Plug 'machakann/vim-highlightedyank'
Plug 'andymass/vim-matchup'
Plug 'kshenoy/vim-signature'
Plug 'arthurdaquinosilva/vim-spotlight'

" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" Database
Plug 'tpope/vim-dadbod'
Plug 'kristijanhusak/vim-dadbod-ui'

" Notes
Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

" Language support
Plug 'sheerun/vim-polyglot'
" Hexokinase compiles a Go color server on install.
if executable('go')
    Plug 'RRethy/vim-hexokinase'
endif

" AI
if executable('claude')
    Plug 'rishi-opensource/vim-claude-code'
endif

call plug#end()
