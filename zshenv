# gnome keyring config to enable keyring for apps that are run from terminal
if [ -n "$DESKTOP_SESSION" ]; then
    eval $(gnome-keyring-daemon --start)
    export SSH_AUTH_SOCK
fi
