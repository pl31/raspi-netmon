#!/usr/bin/env python

import time
import sys
import subprocess
import re
import pkg_resources

pkg_resource.require('liquidcrystal_i2c')
import liquidcrystal_i2c

def get_rx_packets(interface):
  f_name = '/sys/class/net/{}/statistics/rx_packets'.format(interface)
  with open(f_name) as f:
    return int(f.read().strip())

def get_indicator(indicator=None):
  if indicator == '-':
    return '|'
  if indicator == '|':
    return '-'
  else:
    return '-'

def get_ip(interface):
  cmd = 'ip -4 -o addr show eth0'.split()
  stdout = subprocess.check_output(cmd)
  matches = re.findall('.*inet ([0-9\.]*)', stdout)
  if matches:
    return matches[0]
  return '-.-.-.-'

lcd = liquidcrystal_i2c.LiquidCrystal_I2C(0x27,1, clear=False)

interface = 'eth0'
last_rx_packets = get_rx_packets(interface)
time.sleep(1)

indicator = get_indicator()

while True:
  rx_packets = get_rx_packets(interface)
  rx_packets_delta = rx_packets - last_rx_packets
  last_rx_packets = rx_packets

  indicator = get_indicator(indicator)
  
  line1 = get_ip(interface).rjust(16)
  line2 = '{}{:9d} pkt/s'.format(indicator, rx_packets_delta)
  lcd.printline(0, line1)
  lcd.printline(1, line2)
  time.sleep(1)
