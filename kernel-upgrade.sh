#!/bin/sh

# Variable initialization
kernel=""

# Starting the upgrade
echo "Starting kernel upgrade..."

# Checking the $kernel variable
if [ "$kernel" == "" ]; then
	echo "input the kernel version: "
	read kernel;
fi

# Changing directory to the kernel source directory
cd "/usr/src/linux-$kernel"

# Copying the important files
cp "arch/x86/boot/bzImage" "/boot/vmlinuz-"$kernel"-mmsx23"
cp ".config" "/boot/config-"$kernel"-mmsx23"
cp "System.map" "/boot/System.map-"$kernel"-mmsx23"

# Changing directory to /boot
cd /boot

# Creating new symbolic links for the important files
rm config System.map vmlinuz
ln -s "System.map-"$kernel"-mmsx23" System.map
ln -s "config-"$kernel"-mmsx23" config
ln -s "vmlinuz-"$kernel"-mmsx23" vmlinuz

# Creating new entry in elilo.conf
cp "vmlinuz-"$kernel"-mmsx23" "efi/EFI/Slackware"
echo "\

image = vmlinuz-"$kernel"-mmsx23
  initrd = intel-ucode.cpio
  root = /dev/sda4
  label = "$kernel"-mmsx23
  read-only
  description = "Slackware64 custom "$kernel"-mmsx23"

# Linux bootable partition config ends" >> efi/EFI/Slackware/elilo.conf

# Finished installing the new kernel and some additional configurations
echo "Installation is finished. Do you want to do further edits on elilo.conf? (Especially the \"Linux bootable ...\" part which I can't still figure out how to do it :P"
read ask
if [ "$ask" == "y" ]; then
	vim efi/EFI/Slackware/elilo.conf
fi
