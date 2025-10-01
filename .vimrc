source ~/.vim/settings.vim
source ~/.vim/plugins.vim
source ~/.vim/quickscope.vim
source ~/.vim/vim-move.vim
source ~/.vim/fzf.vim
source ~/.vim/vimwiki.vim
source ~/.vim/template.vim
source ~/.vim/nerdtree.vim
source ~/.vim/commands.vim
source ~/.vim/vimspector.vim
source ~/.vim/vista.vim
source ~/.vim/psql.vim
source ~/.vim/vim-dadbod.vim
source ~/.vim/hexokinase.vim
source ~/.vim/claude.vim
source ~/.vim/coc.vim
source ~/.vim/mappings.vim
source ~/.vim/gitgutter.vim
source ~/.vim/default-flat.vim
source ~/.vim/text-dimmer.vim
source ~/.vim/translator.vim

if filereadable(expand('~/dadbod_databases.vim'))
    execute 'source ~/dadbod_databases.vim'
endif
