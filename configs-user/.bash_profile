# Sourcing the .bashrc for local configurations
[ -f ~/.bashrc ] && source ~/.bashrc

# run the ssh-agent using keychain for on-for-all
# ssh-agent then add default private key
#eval `keychain --eval --systemd id_rsa`

# Starting X when logged in from the first tty
[ $(tty) = /dev/tty1 ] && startx
