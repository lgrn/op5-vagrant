#!/usr/bin/env bash

timedatectl set-timezone Europe/Stockholm # timedatectl list-timezones
timedatectl --adjust-system-clock

# wget: may not be included

yum install wget vim mlocate -y -q &>/dev/null

### MANUAL VERSION SELECTION BELOW -- NOT REQUIRED! LATEST VERSION WILL BE GRABBED
### If no file is grabbed, "latest" is grabbed automatically later.

cd /vagrant
OP5URL='--quiet https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive'

# Uncomment a wget line if you want the version specified to replace 'latest':

wget $OP5URL/op5-monitor-7.5.0.x64.tar.gz
# wget $OP5URL/op5-monitor-7.4.11.x64.tar.gz
# wget $OP5URL/op5-monitor-7.4.6.x64.tar.gz
# wget $OP5URL/op5-monitor-7.4.5-20180806.tar.gz
# wget $OP5URL/op5-monitor-7.4.3-20180612.tar.gz
# wget $OP5URL/OP5-Monitor-7.4.4-20180711.tar.gz
# wget $OP5URL/op5-monitor-7.4.2-20180515.tar.gz
# wget $OP5URL/op5-monitor-7.4.1-20180420.tar.gz
# wget $OP5URL/op5-monitor-7.4.0-20180320.tar.gz
# wget $OP5URL/op5-monitor-7.3.21-20180226.tar.gz
# wget $OP5URL/op5-monitor-7.3.20-20180124.tar.gz
# wget $OP5URL/op5-monitor-7.3.20-20180124.tar.gz
# wget $OP5URL/op5-monitor-7.3.19-20171212.tar.gz
# wget $OP5URL/op5-monitor-7.3.2-20161114.tar.gz
# wget $OP5URL/op5-monitor-7.0.0-20140903.tar.gz

# If a version is missing above, the filename may be available from:
# https://www.op5.com/download/archives/ ("Version" dropdown)

### UNSUPPORTED VERSIONS ###

# wget $OP5URL/op5-monitor-6.3.3-20140912.tar.gz

### NO CHANGES BELOW PLEASE ###

if [ ! -f /vagrant/*onitor*gz ]; then
    echo "[>>>] Didn't find any monitor file in /vagrant"
	echo "[>>>] Grabbing Monitor 8 from the information superhighway."
    cd /tmp && wget https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive/Monitor8/Tarball/op5-monitor-8.0.0.x64.tar.gz &>/dev/null && tar xvf *.gz &>/dev/null
    echo "[>>>] Whoosh! Download and unpack complete. Running non-interactive installation script. This will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
else
    echo "[>>>] There's already an op5-monitor file in working dir /vagrant"
    cd /vagrant && tar xvf *onitor*.gz &>/dev/null
    echo "[>>>] That file is now unpacked. Running non-interactive installation script. This will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
fi

echo "[>>>] The provision script for this guest has finished."
echo "[>>>] You should be able to access this Monitor instance on:"
echo "[>>>] https://localhost:4436 (Centos6) or https://localhost:4437 (Centos7)."
echo "[>>>] For more information on guest configuration, see the vagrant file. Have fun!\n\n"
echo "[!!!] If Monitor/Apache/etc needs root, you may want to take note of /etc/pam.d/su "
echo "[!!!] On some boxes, only the 'vagrant' user is allowed to sudo. cat of file:"
echo "[***]"
cat /etc/pam.d/su
echo "[***]"
echo "[>>>] Provisioning done."
