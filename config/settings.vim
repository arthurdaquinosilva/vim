" ~/.vim/config/settings.vim — core Vim options.

syntax on

" ── UI / display ─────────────────────────────────────────────────────────────
set ruler
set number
set relativenumber
set cursorline
set textwidth=80
set cc=60,80,120,160
set fillchars+=vert:\▏
set fillchars+=fold:—
let &fillchars .= ',eob: '
let &t_ZH="\<Esc>[3m"
let &t_ZR="\<Esc>[23m"
set lazyredraw
set noerrorbells

" ── Editing ──────────────────────────────────────────────────────────────────
set linebreak
set nowrap
set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set autoindent
set foldmethod=indent
" Use the system clipboard when the build supports it (macOS). On the Linux VM
" (-clipboard), the OSC52 fallback in functions.vim handles yanks instead.
if has('clipboard')
    set clipboard^=unnamed,unnamedplus
endif

" ── Search ───────────────────────────────────────────────────────────────────
set incsearch
set hlsearch
set ignorecase
set smartcase

" ── Windows / buffers / splits ───────────────────────────────────────────────
set hidden
set splitbelow
set splitright
set noequalalways

" ── Files ────────────────────────────────────────────────────────────────────
set nobackup
set noswapfile
set noundofile

" ── Leader & timings ─────────────────────────────────────────────────────────
let mapleader = " "
set timeoutlen=300
set ttimeout
set ttimeoutlen=10

" ── Completion ───────────────────────────────────────────────────────────────
" Essential for avoiding duplicate completions
set completeopt=menuone,noinsert,noselect
" Avoid showing extra messages when using completion
set shortmess+=c

" ── Terminal ─────────────────────────────────────────────────────────────────
set ttyfast
set re=0

if &term =~ '^screen' || &term =~ '^tmux'
    " Handle Ctrl+Arrow keys
    execute "set <xUp>=\e[1;*A"
    execute "set <xDown>=\e[1;*B"
    execute "set <xLeft>=\e[1;*D"
    execute "set <xRight>=\e[1;*C"
endif

" ── Misc ─────────────────────────────────────────────────────────────────────
set shell=/bin/zsh
set nomodeline
set mouse=a
set spelllang=pt_br,en_us
set path+=**
