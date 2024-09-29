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
    # Get the scandir of the usertree associated with this user
    ENV_FILE="/run/service/usertree-srv/instances/${USER}/env/S6_SCANDIR"
    # We use `eval` here to expand variables contained in $ENV_FILE
    if [ -r "$ENV_FILE" ]; then
        S6_SCANDIR="$(eval "echo $(cat "$ENV_FILE")")" && export S6_SCANDIR
    fi

    if [ -p "${S6_SCANDIR}/.s6-svscan/control" ]; then
        # Check if we use s6-rc
        if [ -h "${XDG_CONFIG_HOME}/s6-rc/compiled" ]; then
            # For convenience
            S6RC_COMPILED="$(realpath "${XDG_CONFIG_HOME}/s6-rc/compiled")"
            S6RC_LIVE="${XDG_RUNTIME_DIR}/s6-rc"
            S6RC_TIMEOUT="5000"
            S6RC_SESSION_BUNDLE="${XDG_SESSION_TYPE}-session"
            export S6RC_COMPILED S6RC_LIVE S6RC_TIMEOUT S6RC_SESSION_BUNDLE

            # Initialize s6-rc if it hasn't been initialized
            if [ ! -h "$S6RC_LIVE" ]; then
                s6-rc-init \
                    -c "$S6RC_COMPILED" \
                    -l "$S6RC_LIVE" \
                    -t "$S6RC_TIMEOUT" \
                    "$S6_SCANDIR"
            fi

            # Start the relevant s6-rc services for this session
            s6-rc \
                -b \
                -l "$S6RC_LIVE" \
                -t "$S6RC_TIMEOUT" \
                change "$S6RC_SESSION_BUNDLE"
        fi

        # Use the DBus session bus that is maintained by the user's supervision
        # tree
        ENV_FILE="${S6_SCANDIR}/messagebus-srv/env/DBUS_SESSION_BUS_ADDRESS"
        if [ -r "$ENV_FILE" ]; then
            DBUS_SESSION_BUS_ADDRESS="$(cat "$ENV_FILE")" && \
                export DBUS_SESSION_BUS_ADDRESS
        fi

        # Use the ssh-agent that is maintained by the user's supervision tree
        ENV_FILE="${S6_SCANDIR}/ssh-agent-srv/env/SSH_AUTH_SOCK"
        if [ -r "$ENV_FILE" ]; then
            SSH_AUTH_SOCK="$(cat "$ENV_FILE")" && export SSH_AUTH_SOCK
        fi
    fi

    # Not needed anymore
    unset ENV_FILE
fi

# Only source this file if we are in a tty session
[ "$XDG_SESSION_TYPE" = "tty" ] && [ -s ~/.bashrc_common ] && . ~/.bashrc_common
