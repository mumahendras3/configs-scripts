#!/bin/sh

# Variable initialization
KERNEL=${KERNEL:-}
KERNELPATH=${KERNELPATH:-/usr/src}
JOBS=${JOBS:-3}
TAG=${TAG:--mmsx23}
# Starting the upgrade
echo "Starting kernel upgrade..."

# Checking the $KERNELPATH, $TAG and $KERNEL variable
if [ "$KERNELPATH" == "/usr/src" ]; then
	echo "input the kernel directory (defaults to $KERNELPATH):"
	read KERNELPATH
	if [ "$KERNELPATH" == "" ]; then 
		echo "Using the default kernel path (/usr/src)"
		KERNELPATH="/usr/src"
	else
		echo "Using $KERNELPATH as the kernel source path"
	fi
else
	echo "Using $KERNELPATH as the kernel source path"
fi

if [ "$KERNEL" == "" ]; then
	echo "input the kernel version (inputting blank space here will cause the script to abort):"
	read KERNEL;
	if [ $KERNEL == "" ]; then
		echo "Aborting the process ..."
		exit 1
	else
		echo "Using version $KERNEL"
	fi
else
	echo "Using version $KERNEL"
fi

if [ "$TAG" == "-mmsx23" ]; then
	echo "input the custom kernel tag/name (defaults to $TAG)"
	read TAG
	if [ "$TAG" == "" ]; then
		echo "Using the default value (-mmsx23)"
		TAG="-mmsx23"
	else
		echo "Using $TAG as the custom tag/name"
	fi
else
	echo "Using $TAG as the custom tag/name"
fi

# Changing directory to the kernel source directory
cd "$KERNELPATH/linux-$KERNEL"

# Copying previously used .config file
echo "Do you want to use the .config file that is currently in use?"
read ASK
if [ "$ASK" == "y" ]; then
	cp "/boot/config-$(uname -r)" .
else
	echo "Which version of kernel that you want to use it's .config file?"
	read ALTKERNEL
	cp "$KERNELPATH/linux-$ALTKERNEL/.config" .
fi

# Begin configuring and building the kernel and kernel modules
make oldconfig
ASK=y
while [ "$ASK" == "y" ]; do
	echo "Do you want to do some more additional editing with the .config file?"
	echo "(Type y here if you want to do that. Type n here to continue to kernel building process)"
	read ASK
	if [ "$ASK" == "y" ]; then
		make menuconfig
	fi
done
make -j"$JOBS" bzImage modules && make -j"$JOBS" modules_install # Installing the kernel modules

# Copying the important files
cp "arch/x86/boot/bzImage" "/boot/vmlinuz-"$KERNEL""$TAG""
cp ".config" "/boot/config-"$KERNEL""$TAG""
cp "System.map" "/boot/System.map-"$KERNEL""$TAG""

# Changing directory to /boot
cd /boot

# Creating new symbolic links for the important files
mv config config.bak
mv System.map System.map.bak
mv vmlinuz vmlinuz.bak
ln -s "System.map-"$KERNEL""$TAG"" System.map
ln -s "config-"$KERNEL""$TAG"" config
ln -s "vmlinuz-"$KERNEL""$TAG"" vmlinuz

# Creating new entry in elilo.conf
cp "vmlinuz-"$KERNEL""$TAG"" "efi/EFI/Slackware"
echo "\

image = vmlinuz-"$KERNEL""$TAG"
  initrd = intel-ucode.cpio
  root = /dev/sda4
  label = "$KERNEL""$TAG"
  read-only
  append = \"init 3\"
  description = \"Slackware64 custom "$KERNEL""$TAG"\"

# Linux bootable partition config ends" >> efi/EFI/Slackware/elilo.conf

# Finished installing the new KERNEL and some additional configurations
echo "Installation is finished. Do you want to do further edits on elilo.conf? (Especially the \"Linux bootable ...\" part which I can't still figure out how to do it :P"
read ASK
if [ "$ASK" == "y" ]; then
	vim efi/EFI/Slackware/elilo.conf
fi

# Finished
echo "Installation is finished"
