" use simple color scheme for linux virtual console
if has('ttyin') && has('ttyout') && $TERM =~ 'linux'
	colorscheme delek
	set guicursor=a:ver1
endif
