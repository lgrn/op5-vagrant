#!/usr/bin/env bash

yum install wget -y -q &>/dev/null

cd /vagrant

wget https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive/Monitor-8-beta/Tarball/op5-monitor-8.beta.centos7-x64.tar.gz

if [ ! -f /vagrant/*onitor*gz ]; then
    echo "[!!!] Missing beta tar.gz in the Vagrant dir. Bye."
else
    echo "[>>>] There's an op5-monitor file in /vagrant -- using it!"
    cd /vagrant && tar xvf *onitor*.gz &> /dev/null
    echo "[>>>] Unpacking done. Running non-interactive installation script. This will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
fi

echo "[>>>] The provision script for this guest has finished. Beta 8 is up at port 4440."

