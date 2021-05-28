export EDITOR=/usr/bin/nvim
[ -x /usr/bin/docker ] && export DOCKER_CONFIG="${HOME}/.config/docker"
if [ -e /etc/slackware-version ]; then
	id -nG | grep -wq wheel && \
      export PATH="${PATH}:/usr/local/sbin:/usr/sbin:/sbin"
fi
if [ ! -e /run/service/user-subtree-manager/down ]; then
    # Use the DBus session bus that is maintained by the user's supervision
    # subtree (if any)
    if [ -d "${HOME}/.config/s6/service/dbus-session-bus" ] || \
        [ -d "${HOME}/.config/s6/rc/compiled/servicedirs/dbus-session-bus" ]; then
        while ! s6-svwait -U "/run/service/${USER}-subtree"; do
            sleep 1
        done
        SVCDIR="/run/${USER}-subtree/service/dbus-session-bus"
        ENVFILE="${SVCDIR}/env/DBUS_SESSION_BUS_ADDRESS"
        while ! s6-svok "$SVCDIR"; do
            sleep 1
        done
        s6-svwait -U "$SVCDIR"
        DBUS_SESSION_BUS_ADDRESS="$(cat "$ENVFILE")"
        export DBUS_SESSION_BUS_ADDRESS
    fi
    # Use the ssh-agent that is maintained by the user's supervision
    # subtree (if any)
    if [ -d "${HOME}/.config/s6/service/ssh-agent" ] || \
        [ -d "${HOME}/.config/s6/rc/compiled/servicedirs/ssh-agent" ]; then
        while ! s6-svwait -U "/run/service/${USER}-subtree"; do
            sleep 1
        done
        SVCDIR="/run/${USER}-subtree/service/ssh-agent"
        ENVFILE="${SVCDIR}/env/SSH_AUTH_SOCK"
        while ! s6-svok "$SVCDIR"; do
            sleep 1
        done
        s6-svwait -U "$SVCDIR"
        SSH_AUTH_SOCK="$(cat "$ENVFILE")"
        export SSH_AUTH_SOCK
    fi
    unset SVCDIR ENVFILE
fi
