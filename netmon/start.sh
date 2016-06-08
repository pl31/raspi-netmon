#!/usr/bin/env sh


# remove running instances and start netmon async
pkill -f netmon.py
~/raspi/netmon/netmon.py &
