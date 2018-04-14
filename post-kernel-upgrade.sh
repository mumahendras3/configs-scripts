#!/bin/sh

# Changing to the Bumblebee-Slackbuilds directory
cd /root/Downloads/Bumblebee-SlackBuilds

# Asking if you want to update the Bumblebee-Slackbuilds files first
echo "Do you want to update the Bumblebee-Slackbuilds files first? [y|n]: "
read choice

if [ "$choice" == "y" ]; then
	# Running the download script in case of any update
	./download.sh
	echo "Do you see any errors when downloading? if you do, say yes here and retry the download script (please input y or n here)"
	read choice
	if [ "$choice" == "y" ]; then
		exit 1
	fi
fi

# Installing the kernel modules needed after every kernel upgrade
echo 'Installing the kernel modules needed after every kernel upgrade'

echo "Building and installing bbswitch"
cd bbswitch
./bbswitch.SlackBuild
installpkg /tmp/bbswitch-*$(uname -r)*_bbsb.t?z

echo "Building and installing nvidia-kernel"
cd ../nvidia-kernel
./nvidia-kernel.SlackBuild
installpkg /tmp/nvidia-kernel-*$(uname -r)*_bbsb.t?z

# Finished
echo "Installation is complete please reboot"
exit 0
