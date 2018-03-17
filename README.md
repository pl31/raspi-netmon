# raspi-netmon

Create a fresh installation of raspian-lite:
- https://www.raspberrypi.org/downloads/raspbian/
- `dd` image to SD-Card and add an empty file `ssh` to root folder
- boot device add ssh into it (user `pi`, password `raspberry`)
  `ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no pi@<ip_of_raspi>`
- configure device as needed using `sudo raspi-config`
  - Enable ssh, i2c

Download and execute the installer:
```
wget -O - https://raw.githubusercontent.com/pl31/raspi-netmon/master/installer/installer.sh | sh
```



