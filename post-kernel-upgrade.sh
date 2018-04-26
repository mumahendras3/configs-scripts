#!/bin/sh

# Variable initialization
BBSBPATH=${BBSBPATH:-}
COMPAT32=${COMPAT32:-}
NVDVER=${NVDVER:-}

# Asking for Bumblebee-Slackbuilds directory if it's not defined yet
if [ "$BBSBPATH" == "" ]; then
	printf 'Bumblebee-Slackbuilds directory is not defined, please specify it: '
	read -r BBSBPATH
	if [ "$BBSBPATH" == "" ]; then
		echo "Blank input is not allowed, exiting"
		exit 1
	else
		echo "Using $BBSBPATH as the directory"
	fi
else
	echo "Using $BBSBPATH as the directory"
fi

# Asking for multilib support
while true
do
	case $COMPAT32 in
		"yes") echo "Enabling multilib support..." && export COMPAT32 && break ;;
		"no") echo "Disabling multilib support..." && break ;;
		"") printf 'Enable multilib support? [yes|no]' ;;
		"*") printf "Wrong input, please answer with \"yes\" or \"no\"" ;;
	esac
	read -r COMPAT32
done

# Asking for NVIDIA driver version
if [ "$NVDVER" == "" ]; then
	printf "Input the version number for the driver (blank means using the default driver that come with the Slackbuilds git repo): "
	read -r $NVDVER
	if [ "$NVDVER" == "" ]; then
		echo "Using the default driver..."
	else
		echo "Using version $NVDVER..."
	fi
else
	echo "Using version $NVDVER..."
fi

# Changing to the Bumblebee-Slackbuilds directory
cd "$BBSBPATH"

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

# Installing nvidia-bumblebee if using other than the default nvidia driver
if [ "$NVDVER" != "" ]; then
	echo "Installing nvidia-bumblebee"
	cd ../nvidia-bumblebee
	VERSION=$NVDVER ./nvidia-bumblebee.SlackBuild
	upgradepkg "/tmp/nvidia-bumblebee-"$NVDVER"-$(uname -m)-1_bbsb.txz"
fi

# Installing nvidia-kernel
echo "Building and installing nvidia-kernel"
cd ../nvidia-kernel
if [ "$NVDVER" == "" ]; then
	./nvidia-kernel.Slackbuild
	installpkg "/tmp/nvidia-kernel-"390.12"_$(uname -r | cut -d '-' -f 1)_$(uname -r | cut -d '-' -f 2)-$(uname -m)-1_bbsb.txz"
else	
	VERSION=$NVDVER ./nvidia-kernel.SlackBuild
	installpkg "/tmp/nvidia-kernel-"$NVDVER"_$(uname -r | cut -d '-' -f 1)_$(uname -r | cut -d '-' -f 2)-$(uname -m)-1_bbsb.txz"
fi

# Finished
echo "Installation is complete please reboot"
exit 0
