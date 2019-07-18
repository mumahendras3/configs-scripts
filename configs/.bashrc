# To avoid sourcing /etc/profile twice when on login shells
[ $0 = bash ] && source /etc/profile

# Local shell configurations
export EDITOR=vim
export VISUAL=vim

# For LFS purposes
export LFS=/mnt/lfs

# Enable vim mode
set -o vi
