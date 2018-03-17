#!/bin/bash

echo "---> Running netmon installer"

echo "---> Install required packages"
apt install -y git python3-setuptools python3-setuptools-git python3-netifaces python3-smbus

echo "---> Install missing modules"
python3 -m easy_install --user git+https://github.com/pl31/python-liquidcrystal_i2c.git

echo "---> Freshly clone repository to home folder"
rm -rf /home/pi/raspi-netmon/
git clone --depth=1 https://github.com/pl31/raspi-netmon.git /home/pi/raspi-netmon/

echo "---> Add start command to /opt/bootlocal.sh"
BOOTLOCAL="/opt/bootlocal.sh"
grep -q "# c0f40bf8" $BOOTLOCAL || echo '/home/tc/raspi-netmon/netmon/start.sh &> /tmp/start_netmon.log	# c0f40bf8' >> $BOOTLOCAL

echo
echo "PLEASE REBOOT DEVICE"
