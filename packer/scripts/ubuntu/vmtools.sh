#!/bin/bash

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso|virtualbox-ovf)
    # Without libdbus virtualbox would not start automatically after compile
    apt-get -y install --no-install-recommends libdbus-1-3
    # The netboot installs the VirtualBox support (old) so we have to remove it
    /etc/init.d/virtualbox-ose-guest-utils stop
    rmmod vboxguest
    aptitude -y purge virtualbox-ose-guest-x11 virtualbox-ose-guest-dkms virtualbox-ose-guest-utils
    aptitude -y install dkms
    mkdir /tmp/vbox
    VER=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox
    yes|sh /tmp/vbox/VBoxLinuxAdditions.run
    umount /tmp/vbox
    rmdir /tmp/vbox
    rm /home/vagrant/*.iso
    ;;

vmware-iso|vmware-vmx)
    mkdir /tmp/vmfusion
    mkdir /tmp/vmfusion-archive
    mount -o loop /home/vagrant/linux.iso /tmp/vmfusion
    tar xzf /tmp/vmfusion/VMwareTools-*.tar.gz -C /tmp/vmfusion-archive
    /tmp/vmfusion-archive/vmware-tools-distrib/vmware-install.pl --default
    umount /tmp/vmfusion
    rm -rf  /tmp/vmfusion
    rm -rf  /tmp/vmfusion-archive
    rm /home/vagrant/*.iso
    ;;

*)
    echo "Unknown Packer Builder Type >>$PACKER_BUILDER_TYPE<< selected."
    echo "Known are virtualbox-iso|virtualbox-ovf|vmware-iso|vmware-vmx."
    ;;

esac
