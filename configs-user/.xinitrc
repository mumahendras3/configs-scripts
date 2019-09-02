#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge in defaults and keymaps
[ -f $sysresources ] && /usr/bin/xrdb -merge $sysresources
[ -f $sysmodmap ] && /usr/bin/xmodmap $sysmodmap
[ -f $userresources ] && /usr/bin/xrdb -merge $userresources
[ -f $usermodmap ] && /usr/bin/xmodmap $usermodmap

# Using the NVIDIA card for the main renderer
#xrandr --setprovideroutputsource Intel NVIDIA-0
#xrandr --auto

# Lower screen brightness
xbacklight -set 50

# Setting DPI to 192
xrandr --dpi 192

# Set the DISPLAY environment variable correctly
#systemctl --user import-environment DISPLAY

# Start some services
#systemctl --user start dunst.service
eval $(/usr/bin/gnome-keyring-daemon --start)
export SSH_AUTH_SOCK # For handling ssh keys with gnome-keyring
urxvtd -q -f -o

# Start i3
#exec /usr/bin/i3 # do this on systemd based system
# for non-systemd distro:
if [ -z "$DESKTOP_SESSION" -a -x /usr/bin/ck-launch-session ]; then
    exec ck-launch-session dbus-launch --exit-with-session /usr/bin/i3
else
    exec dbus-launch /usr/bin/i3
fi
