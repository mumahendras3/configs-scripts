" use simple color scheme for linux virtual console
if $TERM == "linux"
	colorscheme delek
	set guicursor=a:ver1
endif

" use true color based color scheme for GUI clients
" using breezy theme
autocmd UIEnter * set background=light
autocmd UIEnter * colorscheme breezy
" setting lightline color scheme
autocmd UIEnter * let g:lightline = { 'colorscheme': 'breezy' }
