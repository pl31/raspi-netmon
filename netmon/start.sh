#!/usr/bin/env sh
DIR=`dirname "$0"`

set -e

echo "---> Running $1"

echo "---> Set eth0 to promiscious mode"
ifconfig eth0 promisc

echo "---> Starting lighttpd"
rm -f /var/www/htdocs/index.html
sed -i '/^dir-listing.activate/c\dir-listing.activate = "enable"' /usr/local/etc/lighttpd/conf.d/dirlisting.conf
/usr/local/etc/init.d/lighttpd start
# add symlinks for dumps (add pcap extension)
for i in `seq 0 3`; do ln -s /tmp/tcpdumps/tcpdump_eth0_$i /var/www/htdocs/tcpdump_eth0_$i.pcap; done
echo "---> Start tcpdump"
mkdir -p /tmp/tcpdumps
tcpdump -n -U -s 0 -i eth0 -W 4 -C 32M -w /tmp/tcpdumps/tcpdump_eth0_ "not ether host $(cat /sys/class/net/eth0/address)" &

echo "---> Create i2c group"
addgroup i2c || echo "Error creating group i2c (already exists?)"
chown root:i2c /dev/i2c-*
chmod 660 /dev/i2c-*
# tc is member of group i2c
adduser tc i2c

# remove running instances and start netmon async
echo "---> Killing any old processes..."
pgrep -f netmon.py && pkill -f netmon.py
echo "---> Starting netmon..."
# run as user "tc"
( sudo -H -u tc $DIR/netmon.py &> /tmp/netmon.log ) &

echo "---> Start sequence finished"
