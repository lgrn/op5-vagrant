#!/usr/bin/env bash

timedatectl set-timezone Europe/Stockholm # timedatectl list-timezones
timedatectl --adjust-system-clock

# curl: may not be included

echo "[>>>] Installing curl, vim and mlocate."
yum install vim mlocate -y -q &>/dev/null

### MANUAL VERSION SELECTION BELOW -- NOT REQUIRED! LATEST VERSION WILL BE GRABBED
### If no file is grabbed, "latest" is grabbed automatically later.

cd /vagrant
OP5URL='--remote-name --silent https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive'

echo "[>>>] In case you chose to curl a file, it will be downloaded now."
# Uncomment a curl line if you want the version specified to replace 'latest':

# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.6-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.5-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.4-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.3-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.2-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.1-x64.tar.gz
############## note: naming scheme changed >8.0.0 ##########

# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.0.x64.tar.gz

# curl $OP5URL/op5-monitor-7.5.2.x64.tar.gz
# curl $OP5URL/op5-monitor-7.5.1.x64.tar.gz
# curl $OP5URL/op5-monitor-7.5.0.x64.tar.gz
# curl $OP5URL/op5-monitor-7.4.11.x64.tar.gz
# curl $OP5URL/op5-monitor-7.4.6.x64.tar.gz
# curl $OP5URL/op5-monitor-7.4.5-20180806.tar.gz
# curl $OP5URL/op5-monitor-7.4.3-20180612.tar.gz
# curl $OP5URL/OP5-Monitor-7.4.4-20180711.tar.gz
# curl $OP5URL/op5-monitor-7.4.2-20180515.tar.gz
# curl $OP5URL/op5-monitor-7.4.1-20180420.tar.gz
# curl $OP5URL/op5-monitor-7.4.0-20180320.tar.gz
# curl $OP5URL/op5-monitor-7.3.21-20180226.tar.gz
# curl $OP5URL/op5-monitor-7.3.20-20180124.tar.gz
# curl $OP5URL/op5-monitor-7.3.20-20180124.tar.gz
# curl $OP5URL/op5-monitor-7.3.19-20171212.tar.gz
# curl $OP5URL/op5-monitor-7.3.2-20161114.tar.gz
# curl $OP5URL/op5-monitor-7.0.0-20140903.tar.gz

# If a version is missing above, the filename may be available from:
# https://www.op5.com/download/archives/ ("Version" dropdown)

### UNSUPPORTED VERSIONS ###

# curl $OP5URL/op5-monitor-6.3.3-20140912.tar.gz

### NO CHANGES BELOW PLEASE ###

if [ ! -f /vagrant/*onitor*gz ]; then
    echo "[>>>] No monitor file in /vagrant -- you didn't place one, or didn't choose a specific version."
	echo "[>>>] Since there's no installation file, we're grabbing the latest Monitor 8 instead."
    cd /tmp && curl -O https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive/Monitor8/Tarball/op5-monitor-8.0.6-x64.tar.gz &>/dev/null && tar xvf *.gz &>/dev/null
    echo "[>>>] Download and unpack is complete. Now executing non-interactive OP5 installation script. Expect no output: this will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
else
    echo "[>>>] op5-monitor file was found in /vagrant, using that to install."
    cd /vagrant && tar xvf *onitor*.gz &>/dev/null
    echo "[>>>] Download and unpack is complete. Now executing non-interactive OP5 installation script. Expect no output: this will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
fi

echo -e "\n\n"

# Any .lic file in /vagrant ? If so, use it.
echo "[>>>] If a license file exists, it will now be moved into place."
mv -v /vagrant/*.lic /etc/op5license/

echo "[>>>] Time remaining for your OP5 license (check_op5_license):"
/opt/plugins/check_op5_license -w1 -c1 -T d

echo "[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
echo "[>>>] The provision script for this guest has finished."
echo "[>>>] You should be able to access this Monitor instance on:"
echo "[>>>] https://localhost:4436 (Centos6) or https://localhost:4437 (Centos7)."
echo "[>>>] For more information on guest configuration, see the vagrant file. Have fun!"
echo "[!!!] If Monitor/Apache/etc needs root, you may want to take note of /etc/pam.d/su "
echo "[!!!] On some boxes, only the 'vagrant' user is allowed to sudo."
echo "[>>>] DONE. OP5 Vagrant script signing off. Good night."
