"" Plugins initialization
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
" Dracula theme
Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

"" Global variables settings
" Vim-plug window spawn command
let g:plug_window = 'botright 20new'
" Setting lightline color scheme
" Using breezy seems good enough although in linux console
let g:lightline = { 'colorscheme': 'breezy' }
"let g:lightline = { 'colorscheme': 'dracula' }
" Make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
" Better key bindings for UltiSnipsExpandTrigger
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
" Using tree view as default listing style for netrw
let g:netrw_liststyle=3
" Hide netrw_menu
let g:netrw_banner=0
" Set new netrw window default size
let g:netrw_winsize=25
" Open files on the last window when using netrw
"let g:netrw_browse_split = 4

"" Theming controls
" Enable true color based color scheme for terminals that support it
if $COLORTERM == "truecolor"
	set termguicolors " If you want to run vim in a terminal with full color support
	" Breezy theme
	set background=light
	colorscheme breezy
	" Dracula theme
  "colorscheme dracula
  " Enable mouse support
  set mouse=a
endif

"" Interface behaviour settings
" Set numbering with realitve numbering
set number
set relativenumber
" Disable mode status indicator because lightline already has it
set noshowmode
" Interactive mode for find and replace
set inccommand=nosplit
" Set default identation
set shiftwidth=4
" Convert tab to spaces
" Negative value means follow shiftwidth value
set softtabstop=-1
set expandtab
" Default to opening split at the right side
set splitright

"" Keyboard mappings
" Terminal buffer remap for entering normal mode
"tnoremap <Esc> <C-\><C-n>
" Remap changing between windows
nnoremap <silent> <A-h> :wincmd h<CR>
nnoremap <silent> <A-j> :wincmd j<CR>
nnoremap <silent> <A-k> :wincmd k<CR>
nnoremap <silent> <A-l> :wincmd l<CR>
" Same as above but for insert mode
inoremap <silent> <A-h> <Esc>:wincmd h<CR>
inoremap <silent> <A-j> <Esc>:wincmd j<CR>
inoremap <silent> <A-k> <Esc>:wincmd k<CR>
inoremap <silent> <A-l> <Esc>:wincmd l<CR>
" Toggle netrw
nnoremap <silent> <A-e> :Lexplore<CR>
" Same as above but for insert mode
inoremap <silent> <A-e> <Esc>:Lexplore<CR>
" Create a new tab at the end
nnoremap <A-w> :tabedit 
" Same as above but for insert mode
inoremap <A-w> <Esc>:tabedit 
" Exiting all
nnoremap <silent> <A-q> :qa<CR>
" Same as above but for insert mode
inoremap <silent> <A-q> <Esc>:qa<CR>
" Move tab
nnoremap <A-W> :tabmove 
" Same as above but for insert mode
inoremap <A-W> <Esc>:tabmove 

"" General autocommands
" Open file browser automatically only when opening a file
autocmd VimEnter *
            \ if isdirectory(expand("%")) |
                \ if expand("%") != "." |
                    \ cd % |
                \ endif |
            \ else |
                \ cd %:p:h |
            \ endif
