## XDG base directories
# For user-specific data files
export XDG_DATA_HOME="${HOME}/.local/share"
# For user-specific configuration files
export XDG_CONFIG_HOME="${HOME}/.config"
# For user-specific state data (e.g. log files, history files, etc.)
export XDG_STATE_HOME="${HOME}/.local/state"
# For user-specific non-essential (cached) data
export XDG_CACHE_HOME="${HOME}/.cache"

# Create some necessary directories
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME"
mkdir -p "${XDG_STATE_HOME}/zsh"

# Additional environment variables related to user-level services
if [ ! -e /run/service/usertree-manager-srv/down ]; then
    # Use the DBus session bus that is maintained by the user's supervision
    # subtree (if any)
    if [ -d "${HOME}/.config/s6/rc/compiled/servicedirs/dbus-session-bus-srv" ]; then
        while ! s6-svwait -U "/run/service/usertree-${USER}-srv" &>/dev/null; do
            sleep 1
        done
        SVCDIR="/run/usertree-${USER}/service/dbus-session-bus-srv"
        ENVFILE="${SVCDIR}/env/DBUS_SESSION_BUS_ADDRESS"
        while ! s6-svok "$SVCDIR" &>/dev/null; do
            sleep 1
        done
        s6-svwait -U "$SVCDIR"
        DBUS_SESSION_BUS_ADDRESS="$(cat "$ENVFILE")"
        export DBUS_SESSION_BUS_ADDRESS
    fi
    # Use the ssh-agent that is maintained by the user's supervision
    # subtree (if any)
    if [ -d "${HOME}/.config/s6/rc/compiled/servicedirs/ssh-agent-srv" ]; then
        while ! s6-svwait -U "/run/service/usertree-${USER}-srv" &>/dev/null; do
            sleep 1
        done
        SVCDIR="/run/usertree-${USER}/service/ssh-agent-srv"
        ENVFILE="${SVCDIR}/env/SSH_AUTH_SOCK"
        while ! s6-svok "$SVCDIR" &>/dev/null; do
            sleep 1
        done
        s6-svwait -U "$SVCDIR"
        SSH_AUTH_SOCK="$(cat "$ENVFILE")"
        export SSH_AUTH_SOCK
    fi
    unset SVCDIR ENVFILE
fi
