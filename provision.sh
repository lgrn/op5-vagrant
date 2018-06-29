#!/usr/bin/env bash

# some stuff we want, and an upgrade

yum install wget -y && yum upgrade -y

### MANUAL VERSION SELECTION BELOW -- NOT REQUIRED! LATEST VERSION WILL BE GRABBED
### Uncomment below to get a specific version.
### If no file is grabbed, "latest" is grabbed automatically later.

OP5CMD='wget -p /vagrant/ https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive'

# $OP5CMD/op5-monitor-7.4.2-20180515.tar.gz
# $OP5CMD/op5-monitor-7.4.1-20180420.tar.gz
# $OP5CMD/op5-monitor-7.4.0-20180320.tar.gz
# $OP5CMD/op5-monitor-7.3.21-20180226.tar.gz
# $OP5CMD/op5-monitor-7.3.20-20180124.tar.gz
# $OP5CMD/op5-monitor-7.3.20-20180124.tar.gz
# $OP5CMD/op5-monitor-7.3.19-20171212.tar.gz
# $OP5CMD/op5-monitor-7.0.0-20140903.tar.gz

### UNSUPPORTED VERSIONS ###

# $OP5CMD/op5-monitor-6.3.3-20140912.tar.gz


if [ ! -f /vagrant/op5-monitor*gz ]; then
    echo "[>>>] Didn't find any op5-monitor file in the vagrant directory. We're doing it live!"
    cd /tmp && wget https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive/Latest/op5-monitor-latest.tar.gz && tar xvf op5*.gz
    echo "[>>>] Whoosh! Download complete. Running non-interactive installation script."
    cd op5-monitor*/ && ./install.sh --noninteractive
else
    echo "[>>>] There's an op5-monitor file in /vagrant -- using it!"
    cd /vagrant && tar xvf op5*.gz
    echo "[>>>] Running non-interactive installation script."
    cd op5-monitor*/ && ./install.sh --noninteractive
fi
