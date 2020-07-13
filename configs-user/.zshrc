# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/mumahendras3/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Load themes
[ -f ~/.local/share/zsh-themes/dracula/dracula.zsh-theme ] && \
  source ~/.local/share/zsh-themes/dracula/dracula.zsh-theme
[ -f ~/.local/share/zsh-themes/dracula/lib/async.zsh ] && \
  source ~/.local/share/zsh-themes/dracula/lib/async.zsh

# some default environment variables and aliases
export EDITOR=/usr/bin/nvim
alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias la='ls --color=auto -A'
alias grep='grep --color=auto'
alias k='cd /mnt/d/Google\ Drive/Akademik/Fisika\ Teknik/Semester\ 8'
alias nc='nvim ~/.config/nvim/init.vim'
alias zc='nvim ~/.zshrc'
alias n='nvim'
alias nq='nvim-qt'
alias sudo='sudo ' # alias 'sudo ' so that alias after sudo is also expanded

# some special aliases for slackware
if [ -e /etc/slackware-version ]; then
	alias ud='slackpkg update'
	alias ug='slackpkg upgrade-all'
	alias in='slackpkg install-new'
	alias 14.2-build-chroot='build-chroot /usr/local/build-chroots/Slackware64-14.2 /home/mumahendras3/Downloads/slackware64-14.2'
	alias repo-update-14.2='rsync -avzh --progress --partial-dir=.rsync-partial --delete-after rsync://mirror.digitalpacific.com.au/slackware/slackware64-14.2 /home/mumahendras3/Downloads'
	alias repo-update-current='rsync -avzh --progress --partial-dir=.rsync-partial --exclude=source/ --delete-after rsync://mirror.digitalpacific.com.au/slackware/slackware64-current /home/mumahendras3/Downloads'
	alias repo-update-current-all='rsync -avzh --progress --partial-dir=.rsync-partial --delete-after rsync://mirror.digitalpacific.com.au/slackware/slackware64-current /home/mumahendras3/Downloads'
	alias repo-update-all='repo-update-14.2; repo-update-current;'
	[ "$(whoami)" = "mumahendras3" ] && PATH="$PATH:/usr/local/sbin:/usr/sbin:/sbin"
fi

# Enable vi-mode
bindkey -v
export KEYTIMEOUT=1 # For faster mode-switching

# zsh-syntax-highlighting
if [ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
fi

# Start GUI if login from tty1
[ "$TTY" = "/dev/tty1" -a $UID != 0 ] && startx
