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
	echo "Using the default kernel source path ($KERNELPATH)"
else
	echo "Using $KERNELPATH as the kernel source path"
fi

if [ "$KERNEL" == "" ]; then
	printf "input the kernel version (inputting blank space here will cause the script to abort): "
	read -r KERNEL;
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
	echo "Using the default custom tag ($TAG)"
else
	echo "Using $TAG as the custom tag"
fi

# Changing directory to the kernel source directory
cd $KERNELPATH/linux-$KERNEL

# Copying previously used .config file
printf "Do you want to use the .config file that is currently in use? [y|n] "
read -r ASK
if [ "$ASK" == "y" ]; then
	cp /boot/config-$(uname -r) ./.config
else
	printf "Which version of kernel that you want to use its .config file? "
	read -r ALTKERNEL
	cp $KERNELPATH/linux-$ALTKERNEL/.config ./.config
fi

# Begin configuring and building the kernel and kernel modules
make oldconfig
ASK=y
while [ "$ASK" == "y" ]; do
	printf "Do you want to do some more additional editing with the .config file? [Y|n] "
	read -r ASK
	if [ "$ASK" == "y" ]; then
		make menuconfig
	fi
done

# Building and installing the kernel modules
make -j"$JOBS" bzImage modules && make -j"$JOBS" modules_install

# Copying the important files
cp arch/x86/boot/bzImage /boot/vmlinuz-"$KERNEL""$TAG"
cp .config /boot/config-"$KERNEL""$TAG"
cp System.map /boot/System.map-"$KERNEL""$TAG"

# Changing directory to /boot
cd /boot

# Creating new symbolic links for the important files
mv config config.bak
mv System.map System.map.bak
mv vmlinuz vmlinuz.bak
ln -s System.map-"$KERNEL""$TAG" System.map
ln -s config-"$KERNEL""$TAG" config
ln -s vmlinuz-"$KERNEL""$TAG" vmlinuz

# Creating new entry in elilo.conf
cp vmlinuz-"$KERNEL""$TAG" efi/EFI/Slackware
printf "You can add additional boot parameters/kernel parameters here (leave it empty to skip it): "
read PARAMETER
echo "\

image = vmlinuz-"$KERNEL""$TAG"
  initrd = intel-ucode.cpio
  root = /dev/sda4
  label = "$KERNEL""$TAG"
  read-only
  append = \"init 3 vt.default_utf8=1 "$PARAMETER"\"
  description = \"Slackware64 custom "$KERNEL""$TAG"\"

# Linux bootable partition config ends" >> efi/EFI/Slackware/elilo.conf

# Finished installing the new KERNEL and some additional configurations
printf "Installation is finished. Do you want to do further edits on elilo.conf? (Especially the \"Linux bootable ...\" part which I can't still figure out how to do it :P [y|n] "
read -r ASK
if [ "$ASK" == "y" ]; then
	vim efi/EFI/Slackware/elilo.conf
fi

# Finished
echo "Installation is finished"
