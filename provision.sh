#!/usr/bin/env bash
PREFX="[v0.5.3]"
if [[ -f /vagrant/secret.sh ]] ; then
source /vagrant/secret.sh
fi

### START OF FUNCTIONS

usage()
{
    echo "Usage: provision.sh <-r|-p|-v|-t|-m|-n|-x>"
    echo "  -r : Run the script."
    echo "  -p : Install libraries necessary for PHP debugging."
    echo "  -v : Provide verbose output, script is quite silent by default."
    echo "  -m : Supply a Monitor version to download, example: '8.2.3'"
    echo "  -n : [INTERNAL] Install The New UI(tm)"
    echo "  -x : Install extras (see provision.sh)"
}

log()
{
    TIMES='date +%T'
    [[ "$verbose" == "true" ]] && echo "$($TIMES)" "$PREFX" "$1"
}

install_extras()
{
    log "Installing extras."
    yum install vim mlocate yum-utils git -y &>/dev/null
    # add additional repos
    yum-config-manager --add-repo https://cli.github.com/packages/rpm/gh-cli.repo &>/dev/null
    yum-config-manager --add-repo=https://copr.fedorainfracloud.org/coprs/carlwgeorge/ripgrep/repo/epel-7/carlwgeorge-ripgrep-epel-7.repo &>/dev/null
    # install packages from additional repos
    yum install gh ripgrep -y &>/dev/null
    updatedb
    git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
    sh ~/.vim_runtime/install_awesome_vimrc.sh
    log "Extras installed, mlocate db updated."
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

register_rhel_system()
{
    log "Registering system with Red Hat. Please wait."
    subscription-manager register --username $RHEL_USER --password $RHEL_PASS --auto-attach &>/dev/null
    log "Enabling optional RHEL RPMs."
    subscription-manager repos --enable=rhel-7-server-optional-rpms &>/dev/null
    log "Verifying that the system is correctly registered:"
    subscription-manager status
    log "You can un-register this system from the web console, or by using this command:"
    log "# subscription-manager unregister"
}

install_php_debug_tools()
{

    log "PHP debug tools will now be installed, as requested."
    yum install php-devel -y &>/dev/null
    log "php-devel installed via yum."
    log "Installing group 'Development Tools' via yum (be patient)."
    yum groupinstall "Development Tools" -y &>/dev/null
    log "Development tools have been installed. Starting xdebug download."
    cd /tmp && curl -OL https://xdebug.org/files/xdebug-2.4.1.tgz &>/dev/null || log "Curl of xdebug exited $?"
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
        log "PHP debugging likely will not work, continuing anyway."
    fi

    log "Amending config block to end of php.ini (idekey = VSCODE)"

cat >> /etc/php.ini << EOF
zend_extension="/usr/lib64/php/modules/xdebug.so"
xdebug.remote_enable = 1
xdebug.remote_autostart = 1
xdebug.remote_port = 9000
xdebug.idekey = VSCODE
EOF

    log "Setting up a file at monitor/phpinfo.php for your convenience."

cat >> /opt/monitor/op5/ninja/phpinfo.php << EOF
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

}

install_new_ui()
{
log "Initializing new UI install"
cat >> /etc/yum.repos.d/op5-release-head.repo << EOF
##### op5 Monitor
[op5-monitor-updates-head]
name=op5 Monitor Updates head
baseurl=http://repos.dev.itrsent.local/head/el\$releasever/\$basearch/monitor/master/updates/
enabled=1
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-op5
EOF

yum install -y yum-utils && yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo \
&& yum install docker-ce docker-ce-cli containerd.io && systemctl enable docker --now

yum clean all && yum update -y && yum install -y monitor-web-platform

echo '{"insecure-registries": ["docker.dev.itrsent.local"]}"' >> /etc/docker/daemon.json
systemctl restart docker && systemctl restart monitor-web-platform
}

## END OF FUNCTIONS

# initialize flag variables to their defaults

run='false'
phpdebug='false'
verbose='false'
newui='false'
install_extras='false'

while getopts "rpvtnm:x" flag; do
  case ${flag} in
    r) run='true' ;;
    p) phpdebug='true' ;;
    v) verbose='true' ;;
    n) newui='true' ;;
    m) monversion=$OPTARG ;;
    x) install_extras='true' ;;
    *) error 'Unexpected option.' ;;
  esac
done

log "Adding potentially helpful DNS entries"
echo "172.16.150.65 ci-master.dev.itrsent.local" >> /etc/hosts
echo "172.16.20.69 repos.dev.itrsent.local" >> /etc/hosts
echo "172.16.20.221 docker.dev.itrsent.local" >> /etc/hosts

[[ "$run" != "true" ]] && { usage; log "Missing -r flag."; exit 1; }

rhelver="$(head -n1 /etc/redhat-release | tr '[:upper:]' '[:lower:]')"

if [[ $rhelver =~ "red hat" ]] && [[ -n $RHEL_USER ]] && [[ -n $RHEL_PASS ]]; then
    register_rhel_system
else
    log "This isn't Red Hat, or secret.sh isn't configured. Skipping."
    log "Got version: '$rhelver'"
fi

log "Setting default timezone (Europe/Stockholm)."
timedatectl set-timezone Europe/Stockholm &>/dev/null
ln -fs /usr/share/zoneinfo/Europe/Stockholm /etc/localtime

log "Adjusting system clock."
timedatectl --adjust-system-clock > /dev/null

OP5URL="https://d2ubxhm80y3bwr.cloudfront.net/Downloads/op5_monitor_archive"

# Uncomment a curl line below to use that version.
#
# The way this works is that since it will place a file in the vagrantdir
# before the checks below run, it will act just like if you had placed it
# there manually: i.e. it detects a local file and uses that.

# curl $OP5URL/Monitor8/Tarball/op5-monitor-8.0.0.x64.tar.gz

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

# curl $OP5URL/op5-monitor-6.3.3-20140912.tar.gz

# If a version is missing above, the filename may be available from:
# https://resources.itrsgroup.com/downloads
# or, maybe it actually works with the -m flag (pretty likely)!

check_for_monitor_file

if [[ $fileexists == "true" ]]; then
        log "There's already a monitor file here. Using that."
else
	# Figure out what the major version is, then use an URL accordingly
	major_version="$(echo $monversion | head -c 1)"

	[[ -z "$major_version" ]] && { log "Could not figure out what to make of arg '$monversion'/'$major_version' (7/8)."; exit 1; }

	if [[ $major_version == "7" ]]; then
		monurl="https://d2ubxhm80y3bwr.cloudfront.net/Downloads/\
op5_monitor_archive/op5-monitor-$monversion.x64.tar.gz"

		if curl -OL /dev/null --silent --head --fail "$monurl" &>/dev/null ; then
			log "Downloading $monversion as provided in Vagrantfile."
			cd /vagrant && curl -OL "$monurl" &>/dev/null || log "Curl of $monurl exited $?"
		else
			log "Failed to find provided version: $monversion. Exiting."
			exit 1
		fi
	elif [[ $major_version == "8" ]]; then
		monurl="https://d2ubxhm80y3bwr.cloudfront.net/Downloads/\
op5_monitor_archive/Monitor8/Tarball/op5-monitor-$monversion-x64.tar.gz"

		if curl -OL /dev/null --silent --head --fail "$monurl" &>/dev/null ; then
			log "Downloading $monversion as provided in Vagrantfile."
			cd /vagrant && curl -OL "$monurl" &>/dev/null || log "Curl of $monurl exited $?"
		else
			log "Failed to find provided version: $monversion. Exiting."
			exit 1
		fi

	fi
fi

check_for_monitor_file

if [[ $fileexists == "true" ]]; then
    log "Unpacking the Monitor file."
    cd /vagrant && tar xvf *onitor*.gz -C /tmp &>/dev/null
    log "Executing non-interactive \
OP5 installation. This will take some time (~10min)."
    cd /tmp/*onitor* && ./install.sh --noninteractive &>/dev/null
    log "Installation process finished."
else
    log "No monitor file found! Try the -m flag. Exiting."
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
log "$(/opt/plugins/check_op5_license -w1 -c1 -T d)" || log "Cannot check OP5 license. The installation likely failed."

if [[ $phpdebug == "true" ]]; then
    install_php_debug_tools
else
	log "Skipping PHP debug tools."
fi

if [[ $newui == "true" ]]; then
    install_new_ui
else
    log "Skipping new UI."
fi

if [[ $install_extras == "true" ]]; then
    install_extras
else
    log "Skipping extras (-x not set)."
fi

echo "[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
echo "[>>>>>>>>>>>>>>>>>>>>>>>>> F I N I S H E D >>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
echo "[>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>]"
log "The provision script for this guest has finished."
log "You should be able to access Monitor on: https://localhost:4437 (EL7)."
log "If a user needs root, you may want to take note of /etc/pam.d/su since"
log "on some boxes, only the 'vagrant' user is allowed to sudo."
