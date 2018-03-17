#!/usr/bin/env python3

import argparse
import time
import sys
import subprocess
import re
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
  
  lineIP = get_ip(interface).rjust(args.width)
  linePkts = '{}{}{:9d} pkt/s'.format(indicator, ' ' * (args.width-16), rx_packets_delta)

  lcd.printline(0, lineIP)
  for i in range(1, args.height - 2):
    lcd.printline(i, ' ' * args.width)
  lcd.printline(args.height - 1, linePkts)
  time.sleep(1)
