" some global variables settings
let g:plug_window = 'vertical botright new'
let g:deoplete#enable_at_startup = 1

" Vim-plug plugin manager initialization
call plug#begin()
" deoplete for completion framework
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" ultisnips for snippets engine
Plug 'SirVer/ultisnips'
" the snippets library
Plug 'honza/vim-snippets'
call plug#end()
