#!/bin/bash

echo "---> Running netmon installer"

echo "---> Install required packages"
sudo apt install -y git python3-setuptools python3-setuptools-git python3-netifaces python3-smbus

echo "---> Install missing modules"
sudo python3 -m easy_install git+https://github.com/pl31/python-liquidcrystal_i2c.git

echo "---> Freshly clone repository to home folder"
rm -rf ~/raspi-netmon/
git clone --depth=1 https://github.com/pl31/raspi-netmon.git ~/raspi-netmon/

echo "---> Add netmon as systemd service"
sudo cp ~/raspi-netmon/installer/netmon.service /etc/systemd/system
sudo systemctl enable netmon.service

echo "---> Set promiscuous mode for eth0"
sudo cp ~/raspi-netmon/installer/promiscuous@.service /etc/systemd/system
sudo systemctl enable promiscuous@eth0.service

echo
echo "PLEASE REBOOT DEVICE"
