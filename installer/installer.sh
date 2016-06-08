#!/bin/bash

echo "Running netmon installer"

echo "Install required packages"
tce-load -wi git iproute2 python py-smbus

echo "Clone or update repository to home folder"
git clone https://github.com/pl31/raspi-netmon.git ~/raspi-netmon || (cd ~/raspi-netmon && git pull)

echo "Add start command to /opt/bootlocal.sh"
BOOTLOCAL="/opt/bootlocal.sh"
grep -q "# c0f40bf8" $BOOTLOCAL || echo '/home/tc/raspi-netmon/netmon/start.sh	# c0f40bf8' >> $BOOTLOCAL
