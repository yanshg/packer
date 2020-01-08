#!/bin/bash -eux

# Add pkgadd auto-answer file
sudo mkdir -p /tmp
sudo chmod 777 /tmp
echo "mail=" > /tmp/nocheck
echo "instance=overwrite" >> /tmp/nocheck
echo "partial=nocheck" >> /tmp/nocheck
echo "runlevel=nocheck" >> /tmp/nocheck
echo "idepend=nocheck" >> /tmp/nocheck
echo "rdepend=nocheck" >> /tmp/nocheck
echo "space=nocheck" >> /tmp/nocheck
echo "setuid=nocheck" >> /tmp/nocheck
echo "conflict=nocheck" >> /tmp/nocheck
echo "action=nocheck" >> /tmp/nocheck
echo "basedir=default" >> /tmp/nocheck

echo "all" > /tmp/allfiles

if [ -f ~vagrant/.vbox_version ]; then
    sudo -i pkgadd -a /tmp/nocheck -d /media/VBOXADDITIONS_*/VBoxSolarisAdditions.pkg < /tmp/allfiles
fi

