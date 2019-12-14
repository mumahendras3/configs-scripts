" use simple color scheme for linux virtual console
if has('ttyin') && has('ttyout') && $TERM =~ 'linux'
	colorscheme delek
	set guicursor=a:ver1
else
	" use true color based color scheme for GUI clients
	" using breezy theme
	autocmd UIEnter * set background=light
	autocmd UIEnter * colorscheme breezy
	" setting lightline color scheme
	autocmd UIEnter * let g:lightline = { 'colorscheme': 'breezy' }
endif
