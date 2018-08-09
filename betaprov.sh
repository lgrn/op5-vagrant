#!/usr/bin/env bash

### We expect the beta .tar.gz to be available in the same folder as the Vagrantfile.
### This will be rsynced to /vagrant on the guest

cd /vagrant

if [ ! -f /vagrant/OP5*gz ]; then
    echo "[!!!] Missing beta tar.gz in the Vagrant dir. Bye."
else
    echo "[>>>] There's an op5-monitor file in /vagrant -- using it!"
    cd /vagrant && tar xvf OP5*.gz &> /dev/null
    echo "[>>>] Unpacking done. Running non-interactive installation script. This will take some time."
    cd op5-monitor*/ && ./install.sh --noninteractive &>/dev/null
fi

echo "[>>>] The provision script for this guest has finished."

