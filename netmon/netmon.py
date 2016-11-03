#!/usr/bin/env python3

import argparse
import time
import datetime
import sys
import subprocess
import re
import math
import netifaces
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
  netifaces.ifaddresses('eth0')
  try:
    return netifaces.ifaddresses('eth0')[netifaces.AF_INET][0]['addr']
  except:
    return '-.-.-.-'

# Parse arguments
parser = argparse.ArgumentParser(description='Package monitoring')
requiredNamed = parser.add_argument_group('required named arguments')
requiredNamed.add_argument('-x', '--width', help='Display width', type=int, required=True)
requiredNamed.add_argument('-y', '--height', help='Display height', type=int, required=True)
args = parser.parse_args()

# default values
interface = 'eth0'

# Initialize display
lcd = liquidcrystal_i2c.LiquidCrystal_I2C(0x27,1, clear=False)
# create block characters for charting
for c in range(0,8):
  rows = []
  for r in range(0,8):
    if r <= c:
      rows.append(0x1f)
    else:
      rows.append(0x00)
  lcd.createChar(c,rows[::-1])
# create block char array
chars = [ ' ' ]
for c in range(0,8):
  chars.append(chr(c))

# initial values
last_n_rx_packets_delta = [0] * args.width
last_rx_packets = get_rx_packets(interface)
time.sleep(1)
indicator = get_indicator()

while True:
  rx_packets = get_rx_packets(interface)
  rx_packets_delta = rx_packets - last_rx_packets
  last_rx_packets = rx_packets
  last_n_rx_packets_delta.pop(0)
  last_n_rx_packets_delta.append(rx_packets_delta)

  indicator = get_indicator(indicator)

  lineIP = get_ip(interface).rjust(args.width)
  linePkts = '{}{}{:9d} pkt/s'.format(indicator, ' ' * (args.width-16), rx_packets_delta)

  lcd.printline(0, lineIP)
  lcd.printline(1, linePkts)

  if args.height >= 3:
#    lineNow = datetime.datetime.now().strftime("%Y-%m-%d %H:%M").rjust(args.width)
    lineNow = ' ' * args.width
    lcd.printline(2, lineNow)

  if args.height >= 4:
    lineChart = ''
    for pkts in last_n_rx_packets_delta:
      index = 0 if pkts ==0 else int(min(math.log(pkts,4), 8))  # between 0 - 8
      lineChart += chars[index]
    lcd.printline(3, lineChart)

  time.sleep(1)
