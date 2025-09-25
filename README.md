# Vim configuration

Personal Vim setup. Plugin manager is [vim-plug](https://github.com/junegunn/vim-plug); completion is [coc.nvim](https://github.com/neoclide/coc.nvim); colors are [tokyonight](https://github.com/ghifarit53/tokyonight-vim) with custom transparent overrides.

## Layout

```
~/.vim/
├── .vimrc                          Entry point — orchestrates everything below
│
├── config/                         All hand-written configuration
│   ├── settings.vim                Vim options
│   ├── functions.vim               Shared helpers (yank, search, runners…)
│   ├── colorscheme.vim             Theme + highlight overrides
│   ├── mappings.vim                Key bindings
│   └── plugins/
│       ├── _manager.vim            vim-plug bootstrap + Plug list
│       ├── coc.vim
│       ├── dadbod.vim
│       ├── fzf.vim
│       ├── gitgutter.vim
│       ├── hexokinase.vim
│       ├── move.vim
│       ├── nerdtree.vim
│       ├── quickscope.vim
│       └── vimwiki.vim             One file per plugin's config
│
├── after/ftplugin/                 Filetype overrides (JS/TS/PHP)
├── autoload/                       plug.vim lives here
├── plugged/                        vim-plug installs (gitignored)
├── snippets/, UltiSnips/           Snippet definitions
├── spell/                          Custom spell files
├── doc/                            Plugin help (build artifact: doc/tags is gitignored)
│
└── legacy/                         Old inactive code kept for reference
```

## Install on a new machine

```sh
git clone https://github.com/arthurdaquinosilva/vim.git ~/.vim
ln -s ~/.vim/.vimrc ~/.vimrc
vim +PlugInstall +qall
```

On first launch, CoC also auto-installs everything listed in `g:coc_global_extensions` (see `config/plugins/coc.vim`).

## Leader key

`<Space>`. Set in `config/settings.vim`.

## Notable bindings

| Keys | Action |
|---|---|
| `<leader>ff` | FZF file finder |
| `<leader>fa` | Ripgrep (smart-case) across project |
| `<leader>b` | Buffer list |
| `<leader>l` | Lines in current buffer |
| `<leader>h{motion}` | Spotlight a region (dim everything else) |
| `<leader>t` | Toggle NERDTree |
| `<Tab>` / `<S-Tab>` | Cycle buffers |
| `<C-j>/k/h/l` (visual) | Move selected lines |
| `K` | Hover docs (CoC) |
| `gd` | Go to definition |

Full set in `config/mappings.vim`.

## Conventions

- **Vim options** go in `config/settings.vim`.
- **Reusable functions** (called from mappings, autocmds, etc.) go in `config/functions.vim`.
- **Theme + highlight overrides** go in `config/colorscheme.vim`.
- **Key bindings** go in `config/mappings.vim`.
- **Per-plugin tweaks** get their own `config/plugins/<plugin>.vim`. The `_manager.vim` file is special — it holds the `Plug` list and bootstraps vim-plug; it's loaded explicitly first.
- **Filetype-specific overrides** live in `after/ftplugin/<filetype>.vim`.
