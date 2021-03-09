# -*- mode: ruby -*-
# vi: set ft=ruby :

# to use cool generated names, compile namkaran.go and put in:
# foo.vm.hostname = %x(./namkaran [flags]).chomp

Vagrant.configure("2") do |config|
  config.vm.provider "libvirt" do |lv|
    lv.memory = "2048"
    lv.qemu_use_session = false
  end
  # libvirt centos7 example (from scratch)
  config.vm.define "lc7" do |lc7|
    lc7.vm.box = "centos/7"
    lc7.vm.hostname = "lc7"
    lc7.vm.network "forwarded_port", guest: 443, host: 4437
    lc7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.7"
  end
  # libvirt existing box example (see README)
  config.vm.define "lc72" do |lc72|
    lc72.vm.box = "op5"
    lc72.vm.network "forwarded_port", guest: 443, host: 44372
    lc72.vm.hostname = "lc72"
  end
  config.vm.define "lc73" do |lc73|
    lc73.vm.box = "op5"
    lc73.vm.network "forwarded_port", guest: 443, host: 44373
    lc73.vm.hostname = "lc73"
  end
  config.vm.define "lc74" do |lc74|
    lc74.vm.box = "op5"
    lc74.vm.network "forwarded_port", guest: 443, host: 44374
    lc74.vm.hostname = "lc74"
  end
end

Vagrant.configure("2") do |config|
#  NOTE: you probably need to uncomment the below line when running
#        virtualbox as your provider. It conflicts with libvirt (above)
##config.vm.synced_folder ".", "/vagrant", type: 'virtualbox'
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.define "vc7" do |vc7|
    vc7.vm.box = "generic/centos7"
    vc7.vm.hostname = "vc7"
    vc7.vm.network "forwarded_port", guest: 443, host: 4437
    vc7.vm.network "private_network", type: "dhcp"
    vc7.vm.provision "shell", path: "provision.sh", :args => "-r -v -p -m 8.2.7"
  end
  config.vm.define "vc72" do |vc72|
    vc72.vm.box = "op5"
    vc72.vm.network "forwarded_port", guest: 443, host: 44372
    vc72.vm.hostname = "vc72"
  end
  config.vm.define "vr7" do |vr7|
    vr7.vm.box = "generic/rhel7"
    vr7.vm.hostname = "vr7"
    vr7.vm.network "forwarded_port", guest: 443, host: 44377
    vr7.vm.network "private_network", type: "dhcp"
    vr7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.7"
  end
end

# Load user extras
Dir.glob("Vagrantdir/*") do |f|
  load f
end
