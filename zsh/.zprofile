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
        # For convenience
        export S6_SCANDIR="${XDG_RUNTIME_DIR}/s6/service"

        # Check if we use s6-rc
        if [ -h "${XDG_CONFIG_HOME}/s6/rc/compiled" ]; then
            # For convenience
            S6RC_COMPILED="$(realpath "${XDG_CONFIG_HOME}/s6/rc/compiled")"
            S6RC_LIVE="${XDG_RUNTIME_DIR}/s6/rc"
            S6RC_TIMEOUT="5000"
            S6RC_SESSION_BUNDLE="${XDG_SESSION_TYPE}-session"
            export S6RC_COMPILED S6RC_LIVE S6RC_TIMEOUT S6RC_SESSION_BUNDLE

            # Initialize s6-rc
            s6-rc-init \
                -c "$S6RC_COMPILED" \
                -l "$S6RC_LIVE" \
                -t "$S6RC_TIMEOUT" \
                "$S6_SCANDIR"

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
        [ -r "$ENV_FILE" ] && \
            export DBUS_SESSION_BUS_ADDRESS="$(cat "$ENV_FILE")"

        # Use the ssh-agent that is maintained by the user's supervision tree
        ENV_FILE="${S6_SCANDIR}/ssh-agent-srv/env/SSH_AUTH_SOCK"
        [ -r "$ENV_FILE" ] && \
            export SSH_AUTH_SOCK="$(cat "$ENV_FILE")"

        # Not needed anymore
        unset ENV_FILE
    fi
fi
