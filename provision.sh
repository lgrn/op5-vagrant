#!/usr/bin/env bash

OP5VV="0.2"
TIMES='date +%T'
PREFX="[v.$OP5VV]"
timedatectl set-timezone Europe/Stockholm &>/dev/null # timedatectl list-timezones
timedatectl --adjust-system-clock &> /dev/null
ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

### MANUAL VERSION SELECTION BELOW -- NOT REQUIRED!
### IF YOU DON'T UNCOMMENT A LINE, THE LATEST VERSION WILL BE GRABBED

cd /vagrant
OP5URL='--remote-name https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive'

echo $($TIMES) $PREFX "If you chose to curl a file, it will be downloaded now."

# Uncomment a curl line if you want the version specified to replace 'latest':

# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.7-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.6-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.5-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.4-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.3-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.2-x64.tar.gz
# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.1-x64.tar.gz
############## note: naming scheme changed >8.0.0 ##########

# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.0.x64.tar.gz

# curl $OP5URL/op5-monitor-7.5.3.x64.tar.gz
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
# curl $OP5URL/op5-monitor-7.2.2-20160513.tar.gz
# curl $OP5URL/op5-monitor-7.0.0-20140903.tar.gz

# If a version is missing above, the filename may be available from:
# https://www.op5.com/download/archives/ ("Version" dropdown)

### UNSUPPORTED VERSIONS ###

# curl $OP5URL/op5-monitor-6.3.3-20140912.tar.gz

### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ###
###                                          NO CHANGES BELOW PLEASE                                         ###
### !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ###


if [ ! -f /vagrant/*onitor*gz ]; then
    echo $($TIMES) $PREFX "You didn't choose a specific version to install, /vagrant is empty."
	echo $($TIMES) $PREFX "Since there's no installation file, we're grabbing the latest Monitor 8 release."

    LATEST_FILENAME='op5-monitor-8.0.7-x64.tar.gz'

    echo $($TIMES) $PREFX "Latest version is assumed to be: $LATEST_FILENAME (default)"
    cd /tmp && curl -O https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive/Monitor8/Tarball/$LATEST_FILENAME &>/dev/null && tar xvf *.gz &>/dev/null
    echo $($TIMES) $PREFX "Unpack complete. Executing non-interactive OP5 installation. Expect no output, this will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
else
    echo $($TIMES) $PREFX "You manually chose a specific version to install, so we're using that. Unpacking."
    cd /vagrant && tar xvf *onitor*.gz &>/dev/null
    echo $($TIMES) $PREFX "Unpack complete. Executing non-interactive OP5 installation. Expect no output, this will take some time."
    cd *onitor*/ && ./install.sh --noninteractive &>/dev/null
fi

echo -e "\n\n"

# Any .lic file in /vagrant ? If so, use it.
echo $($TIMES) $PREFX "If a license file exists, it will now be moved into place:"
mv -v /vagrant/*.lic /etc/op5license/

echo $($TIMES) $PREFX "Time remaining for your OP5 license (check_op5_license):"
/opt/plugins/check_op5_license -w1 -c1 -T d

echo "[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
echo $($TIMES) $PREFX "The provision script for this guest has finished."
echo $($TIMES) $PREFX "You should be able to access this Monitor instance on:"
echo $($TIMES) $PREFX "https://localhost:4436 (Centos6) or https://localhost:4437 (Centos7)."
echo $($TIMES) $PREFX "For more information on guest configuration, see the vagrant file. Have fun!"
echo $($TIMES) $PREFX "If Monitor/Apache/etc needs root, you may want to take note of /etc/pam.d/su "
echo $($TIMES) $PREFX "On some boxes, only the 'vagrant' user is allowed to sudo."
echo $($TIMES) $PREFX "DONE. OP5 Vagrant script signing off. Good night."
