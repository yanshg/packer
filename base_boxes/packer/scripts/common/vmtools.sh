#!/bin/bash

case "$PACKER_BUILDER_TYPE" in

virtualbox-iso|virtualbox-ovf)
    mkdir /tmp/vbox
    VER=$(cat /home/vagrant/.vbox_version)
    mount -o loop /home/vagrant/VBoxGuestAdditions_$VER.iso /tmp/vbox

    NEEDPATCH=''
    if [ "x$VER" == "x4.3.12" ]; then
        # need apply a patch for VirtualBox Guest Additions on RHEL7/SLES12
        NEEDPATCH=$(grep 'release 7' /etc/redhat-release 2>/dev/null)
        if [ -z "$NEEDPATCH" ]; then
            NEEDPATCH=$(grep 'Server 12' /etc/SuSE-release 2>/dev/null)
        fi
    fi
    if [ ! -z "$NEEDPATCH" ]; then
        # apply the patch
        sh /tmp/vbox/VBoxLinuxAdditions.run --noexec --target /tmp/vbox_source
        mkdir /tmp/vbox_source/sources
        cd /tmp/vbox_source/sources
        tar xjf ../VBoxGuestAdditions-amd64.tar.bz2
        cat > ../vboxguest-4.3.12.patch << '__EOF__'
--- src/vboxguest-4.3.12/vboxguest/r0drv/linux/memobj-r0drv-linux.c.orig	2015-07-16 14:16:33.580099754 -0400
+++ src/vboxguest-4.3.12/vboxguest/r0drv/linux/memobj-r0drv-linux.c	2015-07-16 14:19:07.365111485 -0400
@@ -1533,12 +1533,12 @@
                 /** @todo Ugly hack! But right now we have no other means to disable
                  *        automatic NUMA page balancing. */
 # ifdef RT_OS_X86
-#  if LINUX_VERSION_CODE < KERNEL_VERSION(3, 13, 0)
+#  if LINUX_VERSION_CODE < KERNEL_VERSION(3, 10, 0)
                 pTask->mm->numa_next_reset = jiffies + 0x7fffffffUL;
 #  endif
                 pTask->mm->numa_next_scan  = jiffies + 0x7fffffffUL;
 # else
-#  if LINUX_VERSION_CODE < KERNEL_VERSION(3, 13, 0)
+#  if LINUX_VERSION_CODE < KERNEL_VERSION(3, 10, 0)
                 pTask->mm->numa_next_reset = jiffies + 0x7fffffffffffffffUL;
 #  endif
                 pTask->mm->numa_next_scan  = jiffies + 0x7fffffffffffffffUL;
__EOF__
        patch -p0 < ../vboxguest-4.3.12.patch
        tar cjf ../VBoxGuestAdditions-amd64.tar.bz2 *
        cd ..
        sh ./install.sh 
        cd /tmp
        rm -rf /tmp/vbox_source
    else
        sh /tmp/vbox/VBoxLinuxAdditions.run
    fi
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

parallels-iso|parallels-pvm)
    mkdir /tmp/parallels
    mount -o loop /home/vagrant/prl-tools-lin.iso /tmp/parallels
    /tmp/parallels/install --install-unattended-with-deps
    umount /tmp/parallels
    rmdir /tmp/parallels
    rm /home/vagrant/*.iso
    ;;

*)
    echo "Unknown Packer Builder Type >>$PACKER_BUILDER_TYPE<< selected."
    echo "Known are virtualbox-iso|virtualbox-ovf|vmware-iso|vmware-vmx|parallels-iso|parallels-pvm."
    ;;

esac
