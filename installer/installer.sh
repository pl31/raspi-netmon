#!/bin/bash

echo "Running netmon installer"

echo "Install required packages"
tce-load -wi git python py-smbus

echo "Clone or update repository to home folder"
git clone https://github.com/pl31/raspi-netmon.git ~/raspi-netmon || (cd ~/raspi-netmon && git pull)
