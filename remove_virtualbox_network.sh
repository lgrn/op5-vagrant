#!/bin/bash
# Workaround for issue:
# "A host only network interface you're attempting to configure via DHCP (...)"

VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0

