#!/usr/bin/env bash

# wget: may not be included

yum install wget -y -q &>/dev/null

### MANUAL VERSION SELECTION BELOW -- NOT REQUIRED! LATEST VERSION WILL BE GRABBED
### If no file is grabbed, "latest" is grabbed automatically later.

cd /vagrant
OP5URL='--quiet https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive'

# Uncomment a wget line if you want the version specified to replace 'latest':

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
# wget $OP5URL/op5-monitor-7.0.0-20140903.tar.gz

### UNSUPPORTED VERSIONS ###

# wget $OP5URL/op5-monitor-6.3.3-20140912.tar.gz

### NO CHANGES BELOW PLEASE ###

if [ ! -f /vagrant/*onitor*gz ]; then
    echo "[>>>] Didn't find any monitor file in /vagrant"
	echo "[>>>] Grabbing op5-monitor-latest.tar.gz from the information superhighway."
    cd /tmp && wget https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive/Latest/op5-monitor-latest.tar.gz &>/dev/null && tar xvf *.gz &>/dev/null
    echo "[>>>] Whoosh! Download and unpack complete. Running non-interactive installation script. This will take some time."
    cd op5-monitor*/ && ./install.sh --noninteractive &>/dev/null
else
    echo "[>>>] There's already an op5-monitor file in working dir /vagrant"
    cd /vagrant && tar xvf *onitor*.gz 
    echo "[>>>] That file is now unpacked. Running non-interactive installation script. This will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
fi

echo "[>>>] The provision script for this guest has finished."
echo "[>>>] You should be able to access this Monitor instance on port 4436 (Centos6) or 4437 (Centos7)."
echo "[>>>] For more information on guest configuration, see the vagrant file. Have fun!"