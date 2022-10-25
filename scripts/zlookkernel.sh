#!/bin/bash
### Note about ZLookKernel ##
#
# slackpkg-15 removed the ability to run lilo after a kernel upgrade since
# lilo.conf may contains an initrd. Now slackpkg just advice you:
#    Your kernel image was updated.  Be sure to handle any needed updates
#    to your bootloader.
#
# This plugin try to rebuild the initrd - if any - and try to reinstall lilo
# Note: it works with common configurations. Custom configurations may
#       fails, so use it carefully.
#
# Also it supports EFI elilo.
#
# by default it manage the /boot/vmlinuz image. You have to configure it
# according your lilo/elilo configuration.
#
# It does:
# - check for vmlinuz modifications
# - detect for existant /boot/initrd.gz
# - try to rebuild it by running latest command /boot/initrd-tree/command_line
# - detect the bootloader:
#   - elilo: try to detect which file to copy (vmlinuz, vmlinuz-generic,
#            vmlinuz-huge, initrd.gz) according to /boot/efi/EFI/Slackware/elilo.conf
#   - lilo: run 'lilo -v'
#   - grub: run 'grub-mkconfig -o /boot/grub/grub.cfg'
#   - none: advice that no bootloader was found
#
# If you are switching from kernel huge to kernel generic be sure to run
#
# cd / ; /var/lib/pkgtools/setup/setup.01.mkinitrd
#
# and to configure your lilo.conf
#
# image = /boot/vmlinuz-generic
#   initrd = /boot/initrd.gz
#   root = /dev/xxxxx
#   label = generic
#   read-only

#
# Warning: it works with some common configuration, and may fail with other
# so user it at your own risk. Before reboot please verify.
#
# To use it put PLUGIN_ZLOOKKERNEL=enable
# in /etc/slackpkg/slackpkgplus.conf
#
# set PLUGIN_ZLOOKKERNEL_PROMPT=off
# to avoid it ask all confirmations
#
# set PLUGIN_ZLOOKKERNEL_IMAGE=/boot/vmlinuz-generic
# to manage the generic kernel image instead /boot/vmlinuz
#
#
#
# You can also run it from cmdline to force rebuild the bootloader:
# /usr/libexec/slackpkg/functions.d/zlookkernel.sh

PLUGIN_ZLOOKKERNEL=enable
PLUGIN_ZLOOKKERNEL_PROMPT=off
NVIDIA_KERNEL_PATH=/var/lib/sbopkg/SBo-git/system/nvidia-kernel

if [ "$(basename $0)" == "zlookkernel.sh" ];then
  PLUGIN_ZLOOKKERNEL=force
fi

if [ "$PLUGIN_ZLOOKKERNEL" == "enable" ]||[ "$PLUGIN_ZLOOKKERNEL" == "force" ];then

[ -z "$PLUGIN_ZLOOKKERNEL_IMAGE" ]&&PLUGIN_ZLOOKKERNEL_IMAGE=/boot/vmlinuz

ORIKERNELMD5=$(md5sum $PLUGIN_ZLOOKKERNEL_IMAGE 2>/dev/null;ls -Lli $PLUGIN_ZLOOKKERNEL_IMAGE 2>/dev/null; ls -li $PLUGIN_ZLOOKKERNEL_IMAGE 2>/dev/null)

lookkernel() {
  NEWKERNELMD5=$(md5sum $PLUGIN_ZLOOKKERNEL_IMAGE ; ls -Lli $PLUGIN_ZLOOKKERNEL_IMAGE ; ls -li $PLUGIN_ZLOOKKERNEL_IMAGE)
  if [ "$ORIKERNELMD5" != "$NEWKERNELMD5" ]; then
    KERNEL=$(readlink -f $PLUGIN_ZLOOKKERNEL_IMAGE | sed 's/.*-\([1-9]\)/\1/')
    echo -e "\nYour kernel image was updated (found $KERNEL). You have to rebuild the bootloader.\nDo you want slackpkg to do it? (Y/n)"
    [ ! "$PLUGIN_ZLOOKKERNEL_PROMPT" == "off" ] && answer
    if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "N" ]; then
      INITRD=/boot/initrd.gz
      if [ -e /boot/initrd-tree/command_line ];then
        OINITRD=$(cat /boot/initrd-tree/command_line|grep -- " -o "|sed -r 's/^.* -o *([^ ]*).*$/\1/')
        INITRD=${OINITRD:-$INITRD}

        if [ -f "$INITRD" ];then
          echo -en "Found $INITRD; rebuilding it with:\n  "
          MKINITRD=$(sed -e "s/ *-k *[^ ]\+//g" -e "s/ *$/ -k $KERNEL/" /boot/initrd-tree/command_line)
          echo "  $MKINITRD"
          echo "Do you want continue? (Y/n)"
          [ ! "$PLUGIN_ZLOOKKERNEL_PROMPT" == "off" ] && answer
          if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "N" ]; then
            $MKINITRD
            if [ ! -d "/boot/initrd-tree/lib/modules/$KERNEL" ];then
              echo -e "\nWARNING! the initrd may failed to create\n"
              echo "  The initrd may failed to create." >>$TMPDIR/error.log
            fi
          fi
        fi
      fi


      if [ -e /boot/efi/EFI/Slackware/elilo.conf ];then
        echo -e "\nFound elilo. Copying files to EFI partition"
        COPYDONE=""
        for tocopy in vmlinuz vmlinuz-generic vmlinuz-huge `basename $PLUGIN_ZLOOKKERNEL_IMAGE` `basename $INITRD`;do
          if [ -e /boot/$tocopy ]&&[ -e /boot/efi/EFI/Slackware/$tocopy ]&&grep -E -q "= *$tocopy *$" /boot/efi/EFI/Slackware/elilo.conf ;then
            echo "Do you want to copy $tocopy to EFI partition? (Y/n)"
            [ ! "$PLUGIN_ZLOOKKERNEL_PROMPT" == "off" ] && answer
            if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "N" ]; then
              cp -v /boot/$tocopy /boot/efi/EFI/Slackware/$tocopy && COPYDONE="$COPYDONE $tocopy"
              touch -r /boot/$tocopy /boot/efi/EFI/Slackware/$tocopy
            fi
          fi
        done
        if [ -z "$COPYDONE" ];then
          echo -e "\nWARNING! no files copied. You have to fix bootloader yourself\n"
          echo "  No files copied to the EFI partition found. Fix it yourself" >>$TMPDIR/error.log
        fi
      elif [ -x /sbin/lilo ]&&[ -e /etc/lilo.conf ]; then
        echo -e "\nFound lilo. Do you want to run now: /sbin/lilo ? (Y/n)"
        [ ! "$PLUGIN_ZLOOKKERNEL_PROMPT" == "off" ] && answer
        if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "N" ]; then
          if ! /sbin/lilo -t ;then
            echo "You need to fix your lilo configuration NOW. Then press return to continue."
            read
          fi
          /sbin/lilo -v
        fi
      elif [ -e /boot/grub/grub.cfg ]&&[ -x /usr/sbin/grub-install ]; then
        echo -e "\nFound grub. Do you want to run now: /usr/sbin/grub-mkconfig -o /boot/grub/grub.cfg ? (Y/n)"
        [ ! "$PLUGIN_ZLOOKKERNEL_PROMPT" == "off" ] && answer
        if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "N" ]; then
          if ! /usr/sbin/grub-mkconfig -o /boot/grub/grub.cfg ;then
            echo "You need to fix your grub configuration NOW. Then press return to continue."
            read
          fi
        fi
      else
        echo -e "\nWARNING! slackpkg can't found your bootloader configuration. You have to fix it yourself\n"
        echo "  slackpkg can't found your bootloader configuration. You have to fix it yourself" >>$TMPDIR/error.log
      fi
    fi

    # Personal additions
    if [ -e /var/lib/pkgtools/packages/dkms-*-?_SBo ]; then
      echo -e "\ndkms package found. You have to rebuild all DKMS modules against the newer kernel.\nDo you want slackpkg to do it? (Y/n)"
      [ ! "$PLUGIN_ZLOOKKERNEL_PROMPT" == "off" ] && answer
      if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "N" ]; then
        for mod in /var/lib/dkms/*/[0-9]*[0-9]; do
          mod=${mod#/var/lib/dkms/}
          dkms remove "$mod" && dkms install -k "$KERNEL" "$mod"
        done
      fi
    fi
    if [ -e /var/lib/pkgtools/packages/nvidia-kernel-*-?_SBo ]; then
      echo -e "\nnvidia-kernel package found. You have to rebuild it.\nDo you want slackpkg to do it? (Y/n)"
      [ ! "$PLUGIN_ZLOOKKERNEL_PROMPT" == "off" ] && answer
      if [ "$ANSWER" != "n" ] && [ "$ANSWER" != "N" ]; then
        if [ -d "$NVIDIA_KERNEL_PATH" ]; then
          (
            cd "$NVIDIA_KERNEL_PATH"
            . nvidia-kernel.info
            if [ ! -e "NVIDIA-Linux-x86_64-${VERSION}.run" ]; then
              if [ -e "/home/mumahendras3/Downloads/NVIDIA-Linux-x86_64-${VERSION}.run" ]; then
                ln -sr "/home/mumahendras3/Downloads/NVIDIA-Linux-x86_64-${VERSION}.run" .
              else
                wget --continue --read-timeout=30 "$DOWNLOAD_x86_64" && \
                  cp --reflink=auto "NVIDIA-Linux-x86_64-${VERSION}.run" /home/mumahendras3/Downloads
              fi
            fi
            export KERNEL
            MAKEFLAGS="-j$(nproc)" bash nvidia-kernel.SlackBuild && \
                upgradepkg "/tmp/$(PRINT_PACKAGE_NAME=1 bash nvidia-kernel.SlackBuild)"
          )
        fi
      fi
    fi
  fi
}

if [ "$PLUGIN_ZLOOKKERNEL" == "force" ];then
  ORIKERNELMD5=""
  function answer(){
    read ANSWER
  }
  lookkernel
fi

fi
