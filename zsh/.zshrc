# The following lines were added by compinstall

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/mumahendras3/.zshrc'

autoload -Uz compinit
[ -d ~/.cache/zsh ] || mkdir -p ~/.cache/zsh
compinit -d ~/.cache/zsh/zcompdump-"${ZSH_VERSION}"
# End of lines added by compinstall

# Load themes
[ -f ~/.local/share/zsh-themes/dracula/dracula.zsh-theme ] && \
  source ~/.local/share/zsh-themes/dracula/dracula.zsh-theme
[ -f ~/.local/share/zsh-themes/dracula/lib/async.zsh ] && \
  source ~/.local/share/zsh-themes/dracula/lib/async.zsh
# Additional theme configurations
DRACULA_DISPLAY_CONTEXT=1

# some aliases
alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias la='ls --color=auto -A'
alias grep='grep --color=auto'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log'
alias gp='git push'
alias gu='git pull'
alias nc='nvim ~/.config/nvim/init.vim'
alias zc='nvim ~/.config/zsh/.zshrc'
alias n='nvim'
alias e='sudoedit' # For expanding aliases after sudo
alias bootcamp='cd ~/Documents/backend-bootcamp-braga'
alias cfwu='sudo wg-quick up cf-warp'
alias cfwd='sudo wg-quick down cf-warp'
[ $UID != 0 ] && alias s6-rc="s6-rc -l /run/${USER}-subtree/rc"

# Some special configurations when in Slackware
if [ -e /etc/slackware-version ]; then
  alias ch="less ~/Downloads/slackware64-current/ChangeLog.txt"
	alias ud='sudo slackpkg update'
	alias ug='sudo slackpkg upgrade-all'
	alias in='sudo slackpkg install-new'
  RSYNC_REPO="rsync://mirror-hk.koddos.net/slackware"
	alias repo-update-14.2="rsync -avzh --progress \
      --partial-dir=.rsync-partial --delete-after ${RSYNC_REPO}/slackware64-14.2 \
      ~/Downloads"
	alias repo-update-current="rsync -avzh --progress \
      --partial-dir=.rsync-partial --delete-after ${RSYNC_REPO}/slackware64-current \
      ~/Downloads"
	alias repo-update-all='repo-update-14.2; repo-update-current;'
  unset RSYNC_REPO
fi

# Enable vi-mode
bindkey -v
# Allow backspacing when in insert mode
bindkey '^?' backward-delete-char
# Prevent uppercasing character by pressing delete key when in vi-mode
bindkey "\e[3~" delete-char
# For faster mode-switching when in vi-mode
export KEYTIMEOUT=1

# For root prompt
#[ "$(whoami)" = "root" ] && PS1="%F{red}root ${PS1}"

# zsh-syntax-highlighting
[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Start GUI if login from tty1
[ $UID != 0 ] && [ "$(pgrep -c X)" -lt 1 ] && \
    [ "$TTY" = /dev/tty1 ] && startx || return 0
