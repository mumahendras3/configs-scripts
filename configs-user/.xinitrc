#!/usr/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

list=( $(ls -1 ${HOME}/.66/conf/boot-user) )
for i in ${list[@]};do
    var=$(<${HOME}/.66/conf/boot-user/${i})
    for j in ${var[@]}; do
		export ${j}
    done
done


66-all up
sleep 03

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# Merge in defaults and keymaps
[ -f $sysresources ] && /usr/bin/xrdb -merge $sysresources
[ -f $sysmodmap ] && /usr/bin/xmodmap $sysmodmap
[ -f $userresources ] && /usr/bin/xrdb -merge $userresources
[ -f $usermodmap ] && /usr/bin/xmodmap $usermodmap

# Set the DISPLAY environment variable correctly
#systemctl --user import-environment DISPLAY
dbus-update-activation-environment DISPLAY

# Using the NVIDIA card for the main renderer
#xrandr --setprovideroutputsource Intel NVIDIA-0
#xrandr --auto

# Lower screen brightness
xbacklight -set 50

# Setting DPI to 192
xrandr --dpi 192

# Start some services
#systemctl --user start dunst.service
eval $(/usr/bin/gnome-keyring-daemon --start -C ${XDG_RUNTIME_DIR}/keyring)
export SSH_AUTH_SOCK # For handling ssh keys with gnome-keyring
urxvtd -q -f -o

## Try consolekit
if 66-which -q ck-launch-session; then
	cmd="exec ck-launch-session $@"
else
	cmd="exec $@"
fi

## Select the session to start
#${cmd} jwm
#${cmd} openbox-session
#${cmd} startkde
${cmd} i3
