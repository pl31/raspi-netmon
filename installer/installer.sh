#!/bin/bash

echo "---> Running netmon installer"

echo "---> Install required packages"
sudo apt install -y git lighttpd tcpdump python3-setuptools python3-setuptools-git python3-netifaces python3-smbus

echo "---> Configure webserver"
sudo rm -f /var/www/html/index.lighttpd.html
sudo lighttpd-enable-mod dir-listing

echo "---> Enable tmpfs for tcpdump"
sudo cp ~/raspi-netmon/installer/var-run-tcpdump_eth0.mount
sudo sysctl enable var-run-tcpdump_eth0.mount
sudo sysctl start var-run-tcpdump_eth0.mount
echo "---> Create symbolic links for tcpdump"
sudo sh -c 'for i in `seq 0 3`; do ln -s /var/run/tcpdump_eth0/tcpdump_eth0_$i /var/www/html/tcpdump_eth0_$i.pcap; done' || true
echo "---> Enable tcpdump service"
sudo cp ~/raspi-netmon/installer/tcpdump_eth0.service /etc/systemd/system
sudo systemctl enable tcpdump_eth0.service

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
