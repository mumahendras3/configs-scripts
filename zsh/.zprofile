## XDG base directories
# For user-specific data files
export XDG_DATA_HOME="${HOME}/.local/share"
# For user-specific configuration files
export XDG_CONFIG_HOME="${HOME}/.config"
# For user-specific state data (e.g. log files, history files, etc.)
export XDG_STATE_HOME="${HOME}/.local/state"
# For user-specific non-essential (cached) data
export XDG_CACHE_HOME="${HOME}/.cache"

# GnuPG home directory
[ $UID -ne 0 ] && export GNUPGHOME="${XDG_DATA_HOME}/gnupg"

# Additional environment variables related to s6-based user services
if grep -Fqz s6-svscan /proc/1/cmdline; then
    if [ -d "${XDG_RUNTIME_DIR}/s6/service" ]; then
        S6_SCANDIR="${XDG_RUNTIME_DIR}/s6/service"
        # Use the DBus session bus that is maintained by the user's supervision
        # tree
        ENV_FILE="${S6_SCANDIR}/messagebus-srv/env/DBUS_SESSION_BUS_ADDRESS"
        [ -r "$ENV_FILE" ] && \
            export DBUS_SESSION_BUS_ADDRESS="$(cat "$ENV_FILE")"
        # Use the ssh-agent that is maintained by the user's supervision tree
        ENV_FILE="${S6_SCANDIR}/ssh-agent-srv/env/SSH_AUTH_SOCK"
        [ -r "$ENV_FILE" ] && \
            export SSH_AUTH_SOCK="$(cat "$ENV_FILE")"
        unset ENV_FILE S6_SCANDIR
    fi
fi
