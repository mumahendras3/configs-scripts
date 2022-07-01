## ZSH history configuration
# The file where the history is stored
HISTFILE="${XDG_STATE_HOME}/zsh/history"
# Number of events/commands loaded into memory
HISTSIZE=250000
# Number of events/commands stored in the zsh history file
SAVEHIST=500000
# Do not save duplicate commands to history
setopt HIST_IGNORE_ALL_DUPS
# Do not find duplicate commands when searching
setopt HIST_FIND_NO_DUPS

## Miscellaneous
# Default text editor
export EDITOR=/usr/bin/vim
# Docker config directory
[ -x /usr/bin/docker ] && export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"
# Unset LANGUAGE to avoid translations to other languages when running terminal
# programs
unset LANGUAGE

# The following lines were added by compinstall
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'
zstyle ':completion:*' menu select=1
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle :compinstall filename '/home/mumahendras3/.config/zsh/.zshrc'
autoload -Uz compinit && compinit -d ~/.cache/zsh/zcompdump-"$ZSH_VERSION"
# End of lines added by compinstall

# Load themes
#[ -f ~/.local/share/zsh/themes/dracula/dracula.zsh-theme ] && \
#  . ~/.local/share/zsh/themes/dracula/dracula.zsh-theme
#[ -f ~/.local/share/zsh/themes/dracula/lib/async.zsh ] && \
#  . ~/.local/share/zsh/themes/dracula/lib/async.zsh
# Additional theme configurations
#DRACULA_DISPLAY_CONTEXT=1

# some aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -Alh'
alias grep='grep --color=auto'
alias gs='git status'
alias go='git show'
alias ga='git add'
alias gc='git commit'
alias gd='git diff'
alias gl='git log'
alias gp='git push'
alias gu='git pull'
alias nc='vim ~/.config/nvim/init.vim'
alias zp='vim ~/.config/zsh/.zprofile'
alias zc='vim ~/.config/zsh/.zshrc'
alias e='sudoedit'
alias m="monero-wallet-cli --config-file=${HOME}/.config/monero/wallet-cli.conf"
[ $UID != 0 ] && alias s6-rc="s6-rc -l /run/usertree-${USER}/rc"

# Some special configurations when in Slackware
if [ -e /etc/slackware-version ]; then
    if id -nG | grep -wq wheel; then
        echo $PATH | grep -wq sbin || \
            export PATH="${PATH}:/usr/local/sbin:/usr/sbin:/sbin"
    fi
    alias ch="less ~/Downloads/slackware64-current/ChangeLog.txt"
    alias ud="sudo massconvert32.sh -i ~/Downloads/slackware-current/slackware \
        -d ~/Downloads/multilib/current/slackware64-compat32 && \
        sudo slackpkg update"
    alias ug="sudo upgradepkg \
        ~/Downloads/multilib/current/{,slackware64-compat32/*/}*.t?z && \
        sudo slackpkg upgrade-all"
    alias in="sudo installpkg \
        ~/Downloads/multilib/current/{,slackware64-compat32/*/}*.t?z && \
        sudo slackpkg install-new"
    #RSYNC_REPO="rsync://mirror-hk.koddos.net"
    RSYNC_REPO="rsync://slackware.uk"
    #RSYNC_REPO="rsync://mirrors.kernel.org"
    alias repo-update-15.0="rsync -avzhHAX --progress --delete-after \
        ${RSYNC_REPO}/slackware/slackware-15.0 ~/Downloads"
    alias repo-update-15.0-64="rsync -avzhHAX --progress --delete-after \
        ${RSYNC_REPO}/slackware/slackware64-15.0 ~/Downloads"
    alias repo-update-current="rsync -avzhHAX --progress --delete-after \
        ${RSYNC_REPO}/slackware/slackware-current ~/Downloads"
    alias repo-update-current-64="rsync -avzhHAX --progress --delete-after \
        ${RSYNC_REPO}/slackware/slackware64-current ~/Downloads"
    alias repo-update-multilib-current="rsync -avzhHAX --progress --delete-after --exclude slackware64-compat32 \
	rsync://us.slackware.nl/mirrors/people/alien/multilib/current ~/Downloads/multilib"
    alias repo-update-all="rsync -avzhHAX --progress --delete-after \
        ${RSYNC_REPO}/slackware/slackware{,64}-{15.0,current} ~/Downloads && \
        repo-update-multilib-current"
    unset RSYNC_REPO
fi

# Enable vi-mode
bindkey -v
# Allow backspacing when in insert mode
bindkey '^?' backward-delete-char
# Prevent uppercasing character by pressing delete key when in vi-mode
bindkey "\e[3~" delete-char
# For faster mode-switching when in vi-mode
KEYTIMEOUT=1

# For root prompt
#[ "$(whoami)" = "root" ] && PS1="%F{red}root ${PS1}"

# zsh-bash-completions-fallback
[ -r /usr/share/zsh/plugins/zsh-bash-completions-fallback/zsh-bash-completions-fallback.plugin.zsh ] && \
    . /usr/share/zsh/plugins/zsh-bash-completions-fallback/zsh-bash-completions-fallback.plugin.zsh
# zsh-syntax-highlighting
[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Start GUI if login from tty1
[ $UID -ne 0 ] && [ "$(pgrep -c X)" -lt 1 ] && \
    [ "$TTY" = /dev/tty1 ] && startx || return 0
