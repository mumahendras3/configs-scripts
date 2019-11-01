" Vim-plug auto installation
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif

" Vim-plug plugin manager initialization
call plug#begin()
" deoplete for completion framework
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" ultisnips for snippets engine
Plug 'SirVer/ultisnips'
" the snippets library
Plug 'honza/vim-snippets'
" lightline plugin for cool status bar
Plug 'itchyny/lightline.vim'
" breezy theme
Plug 'fneu/breezy'
" plastic theme
Plug 'flrnprz/plastic.vim'
call plug#end()

" some global variables settings
" vim-plug specific
let g:plug_window = 'vertical botright new'

" deoplete specific
let g:deoplete#enable_at_startup = 1

" plastic theme specific
"set background=dark
"colorscheme plastic
"let g:lightline = { 'colorscheme': 'plastic' }

" breezy theme specific
set background=light
set termguicolors " if you want to run vim in a terminal
colorscheme breezy
let g:lightline = { 'colorscheme': 'breezy' }

" set numbering with realitve numbering
set number
set relativenumber

" disable mode status indicator because lightline already has it
set noshowmode
