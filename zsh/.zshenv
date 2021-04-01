# Use the DBus session bus that is maintained by the user's supervision
# subtree (if any)
if [ ! -e /run/service/user-subtree-manager/down ] && \
    [ -d "${HOME}/.config/s6/service/dbus-session-bus" ]; then
    DBUS_SVCDIR="/run/${USER}-subtree/service/dbus-session-bus"
    DBUS_ADDRFILE="${DBUS_SVCDIR}/env/DBUS_SESSION_BUS_ADDRESS"
    while ! s6-svok "$DBUS_SVCDIR" &>/dev/null; do
        sleep 1
    done
    s6-svwait -U "$DBUS_SVCDIR"
    DBUS_SESSION_BUS_ADDRESS="$(cat "$DBUS_ADDRFILE")"
    export DBUS_SESSION_BUS_ADDRESS
    unset DBUS_SVCDIR DBUS_ADDRFILE
fi
