#!/bin/bash -eux

#pkg update pkg:/package/pkg || true
#pkg update --accept         || true

# Allow root to directly login
/usr/sbin/rolemod -K type=normal root

sed 's/^PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config > /etc/ssh/sshd_config.bak
mv -f /etc/ssh/sshd_config.bak /etc/ssh/sshd_config
