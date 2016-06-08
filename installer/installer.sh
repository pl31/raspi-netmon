#!/bin/bash

echo "---> Running netmon installer"

echo "---> Install required packages"
tce-load -wi git iproute2 python py-smbus lighttpd tcpdump libcap-ng libnl

echo "---> Freshly clone repository to home folder"
rm -rf /home/tc/raspi-netmon/
git clone --depth=1 https://github.com/pl31/raspi-netmon.git /home/tc/raspi-netmon/

echo "---> Add start command to /opt/bootlocal.sh"
BOOTLOCAL="/opt/bootlocal.sh"
grep -q "# c0f40bf8" $BOOTLOCAL || echo '/home/tc/raspi-netmon/netmon/start.sh	# c0f40bf8' >> $BOOTLOCAL

echo "---> backup to SD-Card"
filetool.sh -b

echo
echo "PLEASE REBOOT DEVICE"
