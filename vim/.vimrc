" Initalize vim-plug if it's installed
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if !empty(glob(data_dir . '/autoload/plug.vim'))
    call plug#begin()
    Plug 'fneu/breezy'
    call plug#end()
endif

" Disable vi compatibility (although this should not be needed when ~/.vimrc
" exists)
set nocompatible

"" Interface behaviour settings
" Set numbering with realitve numbering
set number
set relativenumber
" Set default identation
set shiftwidth=4
" Convert tab to spaces
" Negative value means follow shiftwidth value
set softtabstop=-1
set expandtab
" Default to opening split at the right side
set splitright
" Default to 80 columns of characters max per line
set textwidth=80
" Show entered keystrokes when in normal mode
set showcmd

"" Theme settings
" Use original KDE breeze background color
set background=light
" Enable full color support if the terminal emulator supports it
if $COLORTERM == "truecolor" && exists('+termguicolors')
    " https://github.com/alacritty/alacritty/issues/109#issuecomment-440353106
    if $TERM == "alacritty"
        let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
    endif
    set termguicolors
endif
" Set the colorscheme
colorscheme breezy
" Make cursor movement touch-typist friendly (left: l, right: ;)
"noremap l h
"noremap ; l
" Adjust repeat inline search forward/backward
"noremap h ,
"noremap , ;

" Centralize backup/temporary files produced by vim
let &directory = expand('~/.vim/swap//')
set backup
let &backupdir = expand('~/.vim/backup//')
set undofile
let &undodir = expand('~/.vim/undo//')
if !isdirectory(&undodir) | call mkdir(&undodir, "p") | endif
if !isdirectory(&backupdir) | call mkdir(&backupdir, "p") | endif
if !isdirectory(&directory) | call mkdir(&directory, "p") | endif
