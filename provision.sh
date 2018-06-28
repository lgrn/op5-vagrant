#!/usr/bin/env bash

### MANUAL VERSION SELECTION BELOW
### Uncomment a wget-line below to get that version of Monitor.
### If no file exists, "latest" will be grabbed automatically.

# wget -p /vagrant/ https://s3-eu-west-1.amazonaws.com/op5-filebase/Downloads/op5_monitor_archive/op5-monitor-7.4.2-20180515.tar.gz
# wget -p /vagrant/ https://s3-eu-west-1.amazonaws.com/op5-filebase/Downloads/op5_monitor_archive/op5-monitor-7.4.1-20180420.tar.gz

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

