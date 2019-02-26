#!/usr/bin/env bash

# wget: may not be included

echo "[>>>] Naemon Core provisioning script started"

echo "[>>>] Installing stuff via yum"

yum install wget vim mlocate autoconf automake gcc check-devel gperf libdbi-devel libtool git -y 1>/dev/null

autoreconf -i

cd /vagrant

LCDE='https://labs.consol.de/naemon/release/v1.0.9/rhel7/x86_64'

echo "[>>>] Downloading RPM files from consol.de"

wget $LCDE/libnaemon-1.0.9.rhel7.x86_64.rpm \
     $LCDE/naemon-core-1.0.9.rhel7.x86_64.rpm \
     $LCDE/naemon-core-dbg-1.0.9.rhel7.x86_64.rpm \
     $LCDE/naemon-core-debuginfo-1.0.9.rhel7.x86_64.rpm \
     $LCDE/naemon-devel-1.0.9.rhel7.x86_64.rpm \
     $LCDE/naemon-livestatus-1.0.9.rhel7.x86_64.rpm \
     $LCDE/naemon-livestatus-debuginfo-1.0.9.rhel7.x86_64.rpm 1>/dev/null

echo "[>>>] Installing all RPMs"
     
yum install *.rpm -y 1>/dev/null

echo "[>>>] Cloning Merlin"

git clone https://github.com/op5/merlin.git 1>/dev/null && cd merlin/ 

echo "[>>>] Attempting black magic (compiling Merlin)"

./autogen.sh
./configure --disable-auto-postinstall 1>/dev/null
make 1>/dev/null
make install 1>/dev/null
cp merlind /usr/bin

echo "[>>>] Finalizing ritual (creating service files etc.)"

cat > /usr/lib/systemd/system/merlind.service << EOL
[Unit]
Description=Merlin
After=syslog.target network.target naemon.service

[Service]
ExecStart=/usr/bin/merlind --config /etc/merlin/merlin.conf --debug
Restart=always
User=naemon
LimitNOFILE=16384

[Install]
WantedBy=multi-user.target
EOL

mkdir /etc/merlin

cat > /etc/merlin/merlin.conf << EOL

ipc_socket = /var/lib/merlin/ipc.sock;
log_level = debug;
use_syslog = 1;

module {
        log_file = /usr/local/var/log/merlin/neb.log;
}

daemon {
        pidfile = /usr/local/var/run/merlin/merlin.pid;
        log_file = /usr/local/var/log/merlin/daemon.log;

        database {
                enabled = no;

        }

        object_config {
            # TODO, FIXME etc.
        }
}
EOL

chown -Rv naemon:naemon /etc/merlin/
chown -Rv naemon:naemon /usr/local/var/lib/merlin/

mkdir /var/lib/merlin/
chown -Rv naemon:naemon /var/lib/merlin/

systemctl enable naemon --now
systemctl enable merlind --now

echo "[>>>] The provision script for this guest has finished."
echo "[>>>] Running 'yum update' for good measure."
yum update -y -q &>/dev/null
echo "[>>>] Yum done."
echo "[>>>] Good luck :)"