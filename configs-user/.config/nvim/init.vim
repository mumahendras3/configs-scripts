" Vim-plug auto installation
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync
endif
" Vim-plug plugin manager initialization
call plug#begin()
" deoplete for completion framework
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" ultisnips for snippets engine
Plug 'SirVer/ultisnips'
" the snippets library
Plug 'honza/vim-snippets'
" lightline plugin for cool status bar
Plug 'itchyny/lightline.vim'
" breezy theme
Plug 'fneu/breezy'
" vim-polyglot (a bundle of plugins unified and stripped some part)
Plug 'sheerun/vim-polyglot'
" YCM is a code completion engine, similar to deoplete
Plug 'ycm-core/YouCompleteMe', { 'do': 'python3 install.py --clangd-completer --ts-completer' }
" handle all insert mode completion with <tab>
Plug 'ervandew/supertab'
call plug#end()

" some global variables settings
" vim-plug specific
let g:plug_window = 'botright 50vnew'

" deoplete specific
"let g:deoplete#enable_at_startup = 1

" theming controls
" enable true color based color scheme for terminals that support it
if $COLORTERM == "truecolor"
	" breezy theme specific
	set background=light
	set termguicolors "if you want to run vim in a terminal with full color support
	colorscheme breezy
endif

" setting lightline color scheme
" using breezy seems good enough although in linux console
let g:lightline = { 'colorscheme': 'breezy' }

" set numbering with realitve numbering
set number
set relativenumber

" disable mode status indicator because lightline already has it
set noshowmode

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" interactive mode for find and replace
set inccommand=nosplit

" some keyboard mappings
" terminal buffer remap for entering normal mode
"tnoremap <Esc> <C-\><C-n>

" remap changing between windows
noremap <C-h> <C-w><C-h>
noremap <C-j> <C-w><C-j>
noremap <C-k> <C-w><C-k>
noremap <C-l> <C-w><C-l>

" open file browser
noremap <C-\> :30Lexplore! 
noremap! <C-\> :30Lexplore! 
" using tree view as default listing style
let g:netrw_liststyle=3
" hide netrw_menu
let g:netrw_banner=0
" set netrw size when new window opened
let g:netrw_winsize=70
