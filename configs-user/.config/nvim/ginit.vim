" set breezy theme for GUI clients
"set background=light
"colorscheme breezy
" set dracula theme for GUI clients
colorscheme dracula

" use the TUI tabs interface
GuiTabline 0

" enable clipboard for neovim-qt
if GuiName() == 'nvim-qt'
	call GuiClipboard()
endif
