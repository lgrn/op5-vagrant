#!/usr/bin/env bash

# wget: may not be included

yum install wget -y -q &>/dev/null

### MANUAL VERSION SELECTION BELOW -- NOT REQUIRED! LATEST VERSION WILL BE GRABBED
### If no file is grabbed, "latest" is grabbed automatically later.

cd /vagrant
OP5URL='-q https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive'

# Uncomment a wget line if you want the version specified to replace 'latest':

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

if [ ! -f /vagrant/op5-monitor*gz ]; then
    echo "[>>>] Didn't find any op5-monitor file in the vagrant directory. We're doing it live!"
	echo "[>>>] Grabbing op5-monitor-latest.tar.gz from the information superhighway."
    cd /tmp && wget https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive/Latest/op5-monitor-latest.tar.gz &>/dev/null && tar xvf op5*.gz &>/dev/null
    echo "[>>>] Whoosh! Download complete. Running non-interactive installation script. This will take some time."
    cd op5-monitor*/ && ./install.sh --noninteractive &>/dev/null
else
    echo "[>>>] There's an op5-monitor file in /vagrant -- using it!"
    cd /vagrant && tar xvf op5*.gz 
    echo "[>>>] Running non-interactive installation script. This will take some time."
    cd op5-monitor*/ && ./install.sh --noninteractive &>/dev/null
fi

echo "[>>>] The provision script for this guest has finished."
echo "[>>>] You should be able to access this Monitor instance on port 4436 (Centos6) or 4437 (Centos7)."
echo "[>>>] For more information on guest configuration, see the vagrant file. Have fun!"
