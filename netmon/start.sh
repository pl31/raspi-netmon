#!/usr/bin/env sh
DIR=`dirname "$0"`

set -e

echo "Running $1"

echo "Set eth0 to promiscious mode"
ifconfig eth0 promisc

echo "Starting lighttpd"
rm -f /var/www/htdocs/index.html
sed -i '/^dir-listing.activate/c\dir-listing.activate = "enable"' /usr/local/etc/lighttpd/conf.d/dirlisting.conf
/usr/local/etc/init.d/lighttpd start
# add symlinks for dumps (add pcap extension)
for i in `seq 0 3`; do ln -s /tmp/tcpdumps/tcpdump_eth0_$i /var/www/htdocs/tcpdump_eth0_$i.pcap; done
echo "Start tcpdump"
mkdir -p /tmp/tcpdumps
tcpdump -n -U -s 0 -i eth0 -W 4 -C 32M -w /tmp/tcpdumps/tcpdump_eth0_ "not ether host $(cat /sys/class/net/eth0/address)" &

# remove running instances and start netmon async
echo "Killing any old processes..."
pgrep -f netmon.py && pkill -f netmon.py
echo "Starting netmon..."
# ensure library-path as started as root during boot (same as sudo -H)
( PYTHONPATH=$(find /home/tc/.local/lib/python2.7/site-packages/liquidcrystal*.egg) $DIR/netmon.py &> /tmp/netmon.log ) &

echo "Start sequence finished"
