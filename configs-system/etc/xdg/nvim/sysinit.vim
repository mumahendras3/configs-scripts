if $TERM == "linux" && empty($DISPLAY)
	autocmd VimEnter * set background=dark
	autocmd VimEnter * colorscheme delek
	autocmd VimEnter * set guicursor=a:ver1
endif
