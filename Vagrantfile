# -*- mode: ruby -*-
# vi: set ft=ruby :

# to use cool generated names, compile namkaran.go and put in:
#foo.vm.hostname = %x(./namkaran [flags]).chomp

Vagrant.configure("2") do |config|
  config.vm.provider "libvirt" do |lv|
    lv.memory = "2048"
  end
  config.vm.define "lc7" do |lc7|
    lc7.vm.box = "centos/7"
    lc7.vm.hostname = "localhost"
    lc7.vm.network "forwarded_port", guest: 443, host: 4437
    lc7.vm.network "private_network", type: "dhcp"
    lc7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.6"
  end
  config.vm.define "lr7" do |lr7|
    lr7.vm.box = "centos/7"
    lr7.vm.hostname = "localhost"
    lr7.vm.network "forwarded_port", guest: 443, host: 44377
    lr7.vm.network "private_network", type: "dhcp"
    lr7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.6"
  end
end

Vagrant.configure("2") do |config|
#  this line conflicts with libvirt, so if you want it you probably
#  need to delete the whole config block above first. If you have a
#  better solution let me know.
##config.vm.synced_folder ".", "/vagrant", type: 'virtualbox'
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.define "vc7" do |vc7|
    vc7.vm.box = "generic/centos7"
    vc7.vm.hostname = "localhost"
    vc7.vm.network "forwarded_port", guest: 443, host: 4437
    vc7.vm.network "private_network", type: "dhcp"
    vc7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.6"
  end
  config.vm.define "vr7" do |vr7|
    vr7.vm.box = "generic/rhel7"
    vr7.vm.hostname = "localhost"
    vr7.vm.network "forwarded_port", guest: 443, host: 44377
    vr7.vm.network "private_network", type: "dhcp"
    vr7.vm.provision "shell", path: "provision.sh", :args => "-r -v -m 8.2.6"
  end
end

# Load user extras
Dir.glob("Vagrantdir/*") do |f|
  load f
end
