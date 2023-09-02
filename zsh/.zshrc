## Environment variables only useful for interactive shell sessions
# Default text editor
export EDITOR="gvim -v" # Using gvim for clipboard support
# Docker config directory
[ -x /usr/bin/docker ] && export DOCKER_CONFIG="${XDG_CONFIG_HOME}/docker"

## Useful aliases
alias ls='ls --color=auto'
alias ll='ls -lh'
alias la='ls -A'
alias lla='ls -Alh'
alias grep='grep --color=auto'
alias vim='gvim -v' # Using gvim for clipboard support
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
alias sz='npx sequelize-cli'
# Make managing s6-supervised services easier
if [ -n "$S6RC_LIVE" ]; then
    alias s6-rc-db="s6-rc-db -l $S6RC_LIVE"
    alias s6-rc-update="s6-rc-update -l $S6RC_LIVE"
    if [ -n "$S6RC_TIMEOUT" ]; then
        alias s6-rc="s6-rc -l $S6RC_LIVE -t $S6RC_TIMEOUT"
    else
        alias s6-rc="s6-rc -l $S6RC_LIVE"
    fi
fi

## Some special configurations when in Slackware
if [ -e /etc/slackware-version ]; then
    if id -nG | grep -wq wheel; then
        echo "$PATH" | grep -wq sbin || \
            export PATH="${PATH}:/usr/local/sbin:/usr/sbin:/sbin"
    fi
    alias ch="less ~/Downloads/slackware64-current/ChangeLog.txt"
    alias ud="sudo slackpkg update"
    alias ud32="sudo massconvert32.sh -i ~/Downloads/slackware-current/slackware \
        -d ~/Downloads/multilib/current/slackware64-compat32"
    alias ug="sudo slackpkg -batch=on -default_answer=y upgrade-all && \
        sudo slackpkg new-config"
    alias ug32="sudo upgradepkg \
        ~/Downloads/multilib/current/{,slackware64-compat32/*/}*.t?z"
    alias in="sudo slackpkg -onoff=off install-new"
    alias in32="sudo upgradepkg --install-new \
        ~/Downloads/multilib/current/{,slackware64-compat32/*/}*.t?z"
    RSYNC_REPO="rsync://slackware.uk/slackware"
    #RSYNC_REPO="rsync://ftp.acc.umu.se/mirror/slackware.com"
    #RSYNC_REPO="rsync://mirror.yandex.ru/slackware"
    #RSYNC_REPO="rsync://repo.ukdw.ac.id/slackware"
    #RSYNC_REPO="rsync://ftp.slackware.com/slackware"
    alias repo-update-15.0="rsync -avzh --progress --delete-after \
        ${RSYNC_REPO}/slackware-15.0 ~/Downloads"
    alias repo-update-15.0-64="rsync -avzh --progress --delete-after \
        ${RSYNC_REPO}/slackware64-15.0 ~/Downloads"
    alias repo-update-current="rsync -avzh --progress --delete-after \
        ${RSYNC_REPO}/slackware-current ~/Downloads"
    alias repo-update-current-64="rsync -avzh --progress --delete-after \
        ${RSYNC_REPO}/slackware64-current ~/Downloads"
    alias repo-update-multilib-current="rsync -avzh --progress --delete-after --exclude slackware64-compat32 \
	rsync://us.slackware.nl/mirrors/people/alien/multilib/current ~/Downloads/multilib"
    alias repo-update-all="rsync -avzh --progress --delete-after \
        ${RSYNC_REPO}/slackware{,64}-{15.0,current} ~/Downloads && \
        repo-update-multilib-current"
    unset RSYNC_REPO
fi

## Special cases
# Handle alacritty title bar
if [ "$TERM" = alacritty ]; then
    # Executed before the prompt is displayed
    _alacritty_title_precmd() { print -Pn '\e]0;%n@%m:%~\a'; }
    precmd_functions=(_alacritty_title_precmd)
fi
# Append composer-installed CLI tools path to PATH
[ -d ~/.config/composer/vendor/bin ] && \
    export PATH="${PATH}:${HOME}/.config/composer/vendor/bin"

## ZSH specific configurations
# The file where the history is stored
HISTFILE="${XDG_STATE_HOME}/zsh/history"
# Number of events/commands loaded into memory
HISTSIZE=1000000
# Number of events/commands stored in the zsh history file
SAVEHIST=1000000
# Do not save duplicate commands to history
setopt HIST_IGNORE_ALL_DUPS
# Do not find duplicate commands when searching
setopt HIST_FIND_NO_DUPS
# Enable vi-mode
bindkey -v
# Allow backspacing when in insert mode
bindkey '^?' backward-delete-char
# Prevent uppercasing character by pressing delete key when in vi-mode
bindkey "\e[3~" delete-char
# For faster mode-switching when in vi-mode
KEYTIMEOUT=1
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
# zsh-syntax-highlighting
[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && \
    . /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# zsh-bash-completions-fallback
[ -r /usr/share/zsh/plugins/zsh-bash-completions-fallback/zsh-bash-completions-fallback.plugin.zsh ] && \
    . /usr/share/zsh/plugins/zsh-bash-completions-fallback/zsh-bash-completions-fallback.plugin.zsh
