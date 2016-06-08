#!/usr/bin/env sh

set -e

LOGFILE=/tmp/start_netmon.log
echo "Running $1" > $LOGFILE

# remove running instances and start netmon async
echo "Killing any old processes..." >> $LOGFILE
pgrep -f netmon.py && pkill -f netmon.py
echo "Starting netmon..." >> $LOGFILE
( ~/raspi-netmon/netmon/netmon.py &> /tmp/netmon.log ) &

echo "Start sequence finished" >> $LOGFILE
