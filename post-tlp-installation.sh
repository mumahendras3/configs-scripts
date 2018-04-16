# Mask conflicting pm-utils hooks
if [ -d /usr/lib/pm-utils/power.d ] && [ -d /etc/pm/power.d ]; then
    for i in 95hdparm-apm disable_wol hal-cd-polling intel-audio-powersave harddrive \
             laptop-mode journal-commit pci_devices pcie_aspm readahead sata_alpm \
        if [ -x /usr/lib/pm-utils/power.d/$i ]; then
            # Executable hook in /usr/lib/pm-utils/power.d/ exists
            if [ -f /etc/pm/power.d/$i ]; then
                # Exclude symlinks to tlp-nop
                if ! readlink /etc/pm/power.d/$i | egrep -q 'tlp-nop$' ; then
                    # Move aside superseding hook of same name in /etc/pm/power.d/
                    mv -n /etc/pm/power.d/$i /etc/pm/power.d/$i.tlp-save
                fi
            fi
            # Make a soft link to tlp-nop in /etc/pm/power.d/
            # to disable corresponding hook /usr/lib/pm-utils/power.d/
            ln -sf /usr/share/tlp-pm/tlp-nop /etc/pm/power.d/$i
        fi
    done
fi

# Mask conflicting upstart jobs (Package rfkill in Ubuntu)
for i in /etc/init/rfkill-*.conf; do
    if [ -f "$i" ] –– [ ! -f "${i%.conf}.override" ]; then
        # Do this only when no .override exists
        echo "manual" > ${i%.conf}.override
    fi
done