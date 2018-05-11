#!/bin/sh

# Variable initialization
BBSBPATH=${BBSBPATH:-/root/SlackBuilds-extra/Bumblebee-SlackBuilds}
COMPAT32=${COMPAT32:-yes}
NVDVER=${NVDVER:-390.12}
KERNEL=${KERNEL:-$(uname -r)}

# Telling the Bumblebee-Slackbuilds directory that's going to be used
if [ "$BBSBPATH" == "/root/Downloads/Bumblebee-SlackBuilds" ]; then
	echo "Using $BBSBPATH as the Bumblebee-SlackBuilds directory (default directory)"
else
	echo "Using $BBSBPATH as the Bumblebee-SlackBuilds directory"
fi

# Asking for multilib support
while true
do
	case $COMPAT32 in
		"yes")
			echo "Enabling multilib support..."
			break ;;
		"no")
			echo "Disabling multilib support..."
			break ;;
		"*")
			printf "Wrong value has been set to the COMPAT32, please specify the correct value (\"yes\" or \"no\"): "
			read -r COMPAT32
	esac
done

# Telling which NVIDIA driver version is used
if [ "$NVDVER" == "390.12" ]; then
	echo "Using the default driver (390.12)"
else
	echo "Using driver version "$NVDVER""
fi

# Telling which kernel the modules will be built for
if [ "$KERNEL" == "$(uname -r)" ]; then
	echo "Building the modules for $KERNEL (the currently used kernel)..."
	KERNELVER=$(uname -r | cut -d '-' -f 1) # This is stored for later use (when installing the nvidia-kernel)
	TAG=$(uname -r | cut -d '-' -f 2) # This is stored for later use (when installing the nvidia-kernel)
else
	echo "Building the modules for $KERNEL..."
	KERNELVER=$(printf $KERNEL | cut -d '-' -f 1) # This is stored for later use (when installing the nvidia-kernel)
	TAG=$(printf $KERNEL | cut -d '-' -f 2) # This is stored for later use (when installing the nvidia-kernel)
fi

# Changing to the Bumblebee-Slackbuilds directory
cd "$BBSBPATH"

# Asking if you want to update the Bumblebee-Slackbuilds files first
printf "Do you want to update the Bumblebee-Slackbuilds files first? [y|n] "
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
KERNEL=$KERNEL ./bbswitch.SlackBuild
installpkg /tmp/bbswitch-*$KERNEL*_bbsb.t?z

# Installing nvidia-bumblebee if using other than the default nvidia driver
if [ "$NVDVER" != "$(ls /var/log/packages | grep "nvidia-bumblebee-*" | cut -d '-' -f 3)" ]; then
	echo "Upgrading/downgrading nvidia-bumblebee using Nvidia driver version $NVDVER"
	cd ../nvidia-bumblebee
	VERSION=$NVDVER COMPAT32=$COMPAT32 ./nvidia-bumblebee.SlackBuild
	upgradepkg /tmp/nvidia-bumblebee-"$NVDVER"-"$(uname -m)"-?_bbsb.t?z
fi

# Installing nvidia-kernel
echo "Building and installing nvidia-kernel"
cd ../nvidia-kernel
KERNEL=$KERNEL VERSION=$NVDVER ./nvidia-kernel.SlackBuild
installpkg /tmp/nvidia-kernel-"$NVDVER"_"$KERNELVER"_"$TAG"-$(uname -m)-?_bbsb.t?z

# Finished
echo "Installation is complete, please reboot the computer"
exit 0
