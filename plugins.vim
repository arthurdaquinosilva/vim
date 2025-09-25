let vim_plug_installed = 0

let plug_path = expand('$HOME/.vim/autoload/plug.vim')

if !filereadable(plug_path)
  echo " Installing vim-plug ------------"
  silent !mkdir -p $HOME/.vim/autoload
  silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let vim_plug_installed = 1
endif

if vim_plug_installed
  :execute 'source '.fnameescape(plug_path)
endif

if filereadable(plug_path)
    call plug#begin()
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'mhinz/vim-startify'

    Plug 'PhilRunninger/nerdtree-visual-selection'
    Plug 'preservim/nerdtree'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    Plug 'jiangmiao/auto-pairs'
    Plug 'pacha/vem-tabline'
    Plug 'godlygeek/tabular'
    Plug 'tomtom/tcomment_vim'

    Plug 'matze/vim-move'
    Plug 'mg979/vim-visual-multi'
    Plug 'vimoxide/vim-quickscope'
    Plug 'machakann/vim-highlightedyank'
    Plug 'andymass/vim-matchup'

    Plug 'tpope/vim-dadbod'
    Plug 'kristijanhusak/vim-dadbod-ui'
    Plug 'tpope/vim-fugitive'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-surround'

    Plug 'vimwiki/vimwiki', { 'branch': 'dev' }

    Plug 'kshenoy/vim-signature'

    Plug 'sheerun/vim-polyglot'

    Plug 'RRethy/vim-hexokinase'
    
    call plug#end()
endif
