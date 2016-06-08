# raspi-netmon

Create a fresh installation with tinycorelinux and resize the second partition. 

Then boot your raspi and ssh into it:
```
ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no tc@<ip_of_raspi>
```

Download and execute the installer:
```
wget -O - https://raw.githubusercontent.com/pl31/raspi-netmon/master/installer/installer.sh | sh
```



