# Sourcing the .bashrc for local configurations
[ -f ~/.bashrc ] && source ~/.bashrc

# run the ssh-agent and export the appropriate variables
keychain

# Starting X when logged in from the first tty
[ $(tty) = /dev/tty1 ] && startx
