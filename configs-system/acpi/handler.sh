#!/bin/bash
# Default acpi script that takes an entry for all actions

case "$1" in
    button/power)
        case "$2" in
            PBTN|PWRF)
                s6-echo 'PowerButton pressed'
                ;;
            *)
                s6-echo "ACPI action undefined: $2"
                ;;
        esac
        ;;
    button/sleep)
        case "$2" in
            SLPB|SBTN)
                s6-echo 'SleepButton pressed, suspending...'
		DISPLAY=$(ck-list-sessions | grep -A1 "active = TRUE" | sed -e '1d' | cut -d\' -f2)
		if ! test -z $DISPLAY; then
			sudo -u \#$(ck-list-sessions | grep -B6 "active = TRUE" | sed -e '1!d' | cut -d\' -f2) DISPLAY=$DISPLAY i3lock -e -c 323334
		fi
		dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Suspend boolean:true
                ;;
            *)
                s6-echo "ACPI action undefined: $2"
                ;;
        esac
        ;;
    ac_adapter)
        case "$2" in
            AC|ACAD|ADP0)
                case "$4" in
                    00000000)
                        s6-echo 'AC unpluged'
                        ;;
                    00000001)
                        s6-echo 'AC pluged'
                        ;;
                esac
                ;;
            *)
                s6-echo "ACPI action undefined: $2"
                ;;
        esac
        ;;
    battery)
        case "$2" in
            BAT0)
                case "$4" in
                    00000000)
                        s6-echo 'Battery online'
                        ;;
                    00000001)
                        s6-echo 'Battery offline'
                        ;;
                esac
                ;;
            CPU0)
                ;;
            *)  s6-echo "ACPI action undefined: $2" ;;
        esac
        ;;
    button/lid)
        case "$3" in
            close)
                s6-echo 'LID closed, suspending...'
		DISPLAY=$(ck-list-sessions | grep -A1 "active = TRUE" | sed -e '1d' | cut -d\' -f2)
		if ! test -z $DISPLAY; then
			sudo -u \#$(ck-list-sessions | grep -B6 "active = TRUE" | sed -e '1!d' | cut -d\' -f2) DISPLAY=$DISPLAY i3lock -e -c 323334
		fi
		dbus-send --system --print-reply --dest="org.freedesktop.ConsoleKit" /org/freedesktop/ConsoleKit/Manager org.freedesktop.ConsoleKit.Manager.Suspend boolean:true
                ;;
            open)
                s6-echo 'LID opened'
                ;;
            *)
                s6-echo "ACPI action undefined: $3"
                ;;
    esac
    ;;
    *)
        s6-echo "ACPI group/action undefined: $1 / $2"
        ;;
esac

# vim:set ts=4 sw=4 ft=sh et:
