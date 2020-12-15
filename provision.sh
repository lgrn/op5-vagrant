#!/usr/bin/env bash
PREFX="[v0.3]"

usage()
{
    echo "Usage: provision.sh <-r|-p|-v|-t|-m>"
    echo "  -r : Run the script."
    echo "  -p : Install libraries necessary for PHP debugging."
    echo "  -v : Provide verbose output, script is quite silent by default."
    echo "  -m : Supply a Monitor version to download, \
example: '8.2.3' (8+ only!)"
}

log()
{
    TIMES='date +%T'
    [[ "$verbose" == "true" ]] && echo "$($TIMES)" "$PREFX" "$1"
}

check_for_monitor_file()
{
fileexists="false"
for filecheck in /vagrant/*onitor*gz
do
    if [ -e "$filecheck" ]
    then
        fileexists="true"
        log "Filecheck found:"
        ls -alh /vagrant | grep -i monitor
        break
    else
        log "Filecheck failed:"
        ls -alh /vagrant | grep -i monitor
    fi
done
}

while getopts "rpvtm:" flag; do
  case ${flag} in
    r) run='true' ;;
    p) phpdebug='true' ;;
    v) verbose='true' ;;
    m) monversion=$OPTARG ;;
    *) error "Unexpected option." ;;
  esac
done

[[ "$run" != "true" ]] && { usage; log "Missing -r flag."; exit 1; }

log "Setting default timezone (Europe/Stockholm)."
timedatectl set-timezone Europe/Stockholm &>/dev/null
ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

log "Adjusting system clock."
timedatectl --adjust-system-clock > /dev/null

log "TIP: If downloads are slow, place the tar.gz in your vagrantdir beforehand."

if [[ -n $monversion ]]; then
    monurl="https://d2ubxhm80y3bwr.cloudfront.net/Downloads/\
op5_monitor_archive/Monitor8/Tarball/op5-monitor-$monversion-x64.tar.gz"

    if curl -O /dev/null --silent --head --fail "$monurl" &>/dev/null ; then
        log "Downloading $monversion as provided."
        cd /vagrant && curl -O "$monurl" &>/dev/null && block_curl='true'
    else
        log "Failed to find provided version: $monversion. Exiting."
        exit 1
    fi
else
    log "-m wasn't provided, falling back to legacy mode."

    cd /vagrant || exit 1

    OP5URL="-O \
https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive"
    LATEST_FILENAME='/Monitor8/Tarball/op5-monitor-8.2.3-x64.tar.gz'

check_for_monitor_file && echo $fileexists
if ((fileexists == "true")); then
    block_curl='true'
fi

if [[ "$block_curl" != 'true' ]]; then
    # Uncomment a curl line below to replace 'latest'.
    #
    # The way this works is that since it will place a file in the vagrantdir
    # before the checks below run, it will act just like if you had placed it
    # there manually: i.e. it detects a local file and uses that.

    ############## note: naming scheme changed >8.0.0 ##########

    # curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.0.x64.tar.gz

    # curl $OP5URL/op5-monitor-7.5.13.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.12.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.11.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.10.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.9.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.8.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.7.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.6.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.5.x64.tar.gz
    # curl $OP5URL/op5-monitor-7.5.4.x64.tar.gz
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
    # https://resources.itrsgroup.com/downloads

    ### UNSUPPORTED VERSIONS ###

    # curl $OP5URL/op5-monitor-6.3.3-20140912.tar.gz
fi

    check_for_monitor_file && echo $fileexists
    if ((fileexists == "false")); then
        log "No Monitor file found, fixing that: downloading $LATEST_FILENAME."
        cd /vagrant && curl $OP5URL$LATEST_FILENAME &>/dev/null
    fi

fi

check_for_monitor_file && echo $fileexists
if ((fileexists == "true")); then
    log "Unpacking the Monitor file."
    cd /vagrant && tar xvf *onitor*.gz &>/dev/null
    log "Executing non-interactive \
OP5 installation. This will take some time (~10min)."
    cd *onitor* && ./install.sh --noninteractive &>/dev/null
    log "Installation process finished."
else
    log "No monitor file found! Exiting."
    exit 1
fi

if ls /var/lib/yum/transaction-* 1> /dev/null 2>&1; then
    log "Sanity check: Unfinished yum transactions!"
    log "Sanity check: Preserving yum log as /var/log/yum.log.gz first."
    gzip -9 /var/log/yum.log
    log "Sanity check: Completing transactions."
    yum-complete-transaction &>/dev/null && log "Sanity check: Done."
else
    log "Sanity check: No unfinished transactions (that's good)."
fi

log "Using *.lic file from /vagrant, if you put it there."

if [[ -f /vagrant/op5license.lic ]]
then
    mv -v /vagrant/op5license.lic /etc/op5license/
    log "License file moved into place."
else
    log "No license file found, this will be a trial run."
fi

log "Time remaining for your OP5 license (check_op5_license):"
log "$(/opt/plugins/check_op5_license -w1 -c1 -T d)"

if ((phpdebug == "true")); then

    log "PHP debug tools will now be installed, as requested."
    yum install php-devel -y &>/dev/null
    log "php-devel installed via yum."
    log "Installing group 'Development Tools' via yum (be patient)."
    yum groupinstall "Development Tools" -y &>/dev/null
    log "Development tools have been installed. Starting xdebug download."
    cd /tmp && curl -O https://xdebug.org/files/xdebug-2.4.1.tgz &>/dev/null
    log "xdebug downloaded."
    tar xvf xdebug-2.4.1.tgz &>/dev/null && cd xdebug* || exit 1
    log "Running phpize."
    phpize
    log "Configuring xdebug and running make + install."
    ./configure --enable-xdebug &>/dev/null && \
    make &>/dev/null && make install &>/dev/null

    if [[ -f /usr/lib64/php/modules/xdebug.so ]]
        then
        log "/usr/lib64/php/modules/xdebug.so present and accounted for."
    else
        log "xdebug.so is not in /usr/lib64/php/modules/ !!!"
    fi

    log "Amending config block to end of php.ini (idekey = VSCODE)"

cat >> /etc/php.ini <<EOF
zend_extension="/usr/lib64/php/modules/xdebug.so"
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.remote_port = 9000
xdebug.idekey = VSCODE
EOF

    log "Setting up a file at monitor/phpinfo.php for your convenience."

cat >> /opt/monitor/op5/ninja/phpinfo.php <<EOF
<?php
phpinfo();
?>
EOF

    log "Trying to copy vagrants authorized_keys to root. Use:"
    log ".vagrant/machines/centos7/virtualbox/private_key to SSH in as root."

    if [[ -f /home/vagrant/.ssh/authorized_keys ]]
        then
        cd /home/vagrant/.ssh/
        mkdir -p /root/.ssh && cp -fv authorized_keys /root/.ssh
    else
        log "Oh no! There's no authorized_keys to copy :("
    fi

    log "Done."
    log "Do this to add the machine to your ssh config (example):"
    log "vagrant ssh-config centos7 >> ~/.ssh/config"
fi

echo "[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
echo "[>>>>>>>>>>>>>>>>>>>>>>>>> F I N I S H E D >>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
echo "[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
log "The provision script for this guest has finished."
log "You should be able to access Monitor on: https://localhost:4437 (EL7)."
log "If a user needs root, you may want to take note of /etc/pam.d/su since"
log "on some boxes, only the 'vagrant' user is allowed to sudo."
