#!/bin/bash

# Detect virtualization environment
virt=$(systemd-detect-virt)

if [[ "$virt" != "none" ]]; then
    # Disable Wayland if GDM custom config exists
    if [[ -e /etc/gdm/custom.conf ]]; then
        echo "Disabling Wayland in GDM..."
        sed -i -e 's|#WaylandEnable=false|WaylandEnable=false|g' /etc/gdm/custom.conf
    fi
    # Disable Wayland if SDDM custom config exists
    if [[ -e /etc/sddm.conf.d/kde_settings.conf ]]; then
        sed -i 's:Session=.*:Session=plasmax11:g' /etc/sddm.conf.d/kde_settings.conf
    fi
fi

if [[ "$virt" == "none" ]]; then
    echo "Physical machine or unknown virtualization detected. Skipping mkinitcpio configuration."
elif [[ "$virt" == "oracle" ]]; then
    # VirtualBox detected
    echo "VirtualBox detected. Enabling vboxservice..."
    systemctl enable vboxservice.service
elif [[ "$virt" == "vmware" ]]; then
    # VMware detected
    echo "VMware detected. Enabling vmtoolsd..."
    systemctl enable vmtoolsd.service
    systemctl enable vmware-networks.service
    systemctl enable vmware-vmblock-fuse.service
else
    # No specific virtualization detected
    echo "No specific virtualization detected. Configuring mkinitcpio..."
    sed -i 's/MODULES=.*/MODULES=(virtio virtio_blk virtio_pci virtio_net)/g' /etc/mkinitcpio.conf
    mkinitcpio -P
fi



