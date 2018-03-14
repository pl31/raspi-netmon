#!/bin/bash

echo "---> Running netmon installer"

echo "---> Install required packages"
tce-load -wi git iproute2 python python-setuptools py-smbus lighttpd tcpdump libcap-ng libnl
echo "---> Install liquidcrystal_i2c"
python -m easy_install --user https://github.com/pl31/python-liquidcrystal_i2c/archive/master.zip

echo "---> Freshly clone repository to home folder"
rm -rf /home/tc/raspi-netmon/
git clone --depth=1 https://github.com/pl31/raspi-netmon.git /home/tc/raspi-netmon/

echo "---> Add start command to /opt/bootlocal.sh"
BOOTLOCAL="/opt/bootlocal.sh"
grep -q "# c0f40bf8" $BOOTLOCAL || echo '/home/tc/raspi-netmon/netmon/start.sh &> /tmp/start_netmon.log	# c0f40bf8' >> $BOOTLOCAL

echo "---> backup to SD-Card"
filetool.sh -b

echo
echo "PLEASE REBOOT DEVICE"
